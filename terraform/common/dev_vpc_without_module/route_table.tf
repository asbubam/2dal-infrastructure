# dev_public
resource "aws_route_table" "dev_public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }

  tags = {
    Name = "dev-public"
  }
}

resource "aws_route_table_association" "dev_public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.dev_public.id
}

resource "aws_route_table_association" "dev_public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.dev_public.id
}

# dev_private_1a
resource "aws_route_table" "dev_private_1a" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_1a.id
  }

  tags = {
    Name = "dev-private-1a"
  }
}

resource "aws_route_table_association" "dev_private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.dev_private_1a.id
}

# dev_private_1c
resource "aws_route_table" "dev_private_1c" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_1c.id
  }

  tags = {
    Name = "dev-private-1c"
  }
}

resource "aws_route_table_association" "dev_private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.dev_private_1c.id
}
