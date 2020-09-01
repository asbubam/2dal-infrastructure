# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

# internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

# default network ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id,
    aws_subnet.database[*].id,
  )


  tags = merge(var.tags, map("Name", format("%s-default", var.name)))
}

# default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, map("Name", format("%s-default", var.name)))
}

# public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.public_subnet_tags, var.tags, map("Name", format("%s-public-%s", var.name, var.azs[count.index])))
}

# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.private_subnet_tags, var.tags, map("Name", format("%s-private-%s", var.name, var.azs[count.index])))
}

# private database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, map("Name", format("%s-db-%s", var.name, var.azs[count.index])))
}

resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  name        = var.name
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(var.tags, map("Name", format("%s", var.name)))
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, map("Name", format("%s-public", var.name)))
}

# private route table
resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    #nat_gateway_id = "${aws_nat_gateway.this.*.id[count.index]}"
    instance_id = aws_instance.bastion.id
  }

  tags = merge(var.tags, map("Name", format("%s-private-%s", var.name, var.azs[count.index])))
}

# route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnets)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# SG for SSH Connect to Bastion
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH connect to bastion instance"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, map("Name", format("%s-bastion", var.name)))
}

# SG for Connect to Private Subnet from Bastion
resource "aws_security_group" "ssh_from_bastion" {
  name        = "ssh_from_bastion"
  description = "Allow SSH connect from bastion instance"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  tags = merge(var.tags, map("Name", format("%s-ssh-from-bastion", var.name)))
}

# bastion EC2
resource "aws_instance" "bastion" {
  ami               = var.bastion_ami
  instance_type     = var.bastion_instance_type
  availability_zone = var.bastion_availability_zone
  subnet_id         = var.bastion_subnet_id
  key_name          = var.bastion_keypair_name

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
    aws_default_security_group.default.id,
  ]

  associate_public_ip_address = true
  source_dest_check           = false
  disable_api_termination     = true

  iam_instance_profile = var.bastion_instance_profile

  tags = merge(var.tags, map("Name", format("%s-bastion", var.name)))
}

# bastion EIP
resource "aws_eip" "bastion" {
  vpc      = true
  instance = aws_instance.bastion.id
}
