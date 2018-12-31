data "aws_ami" "amazon_linux_nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "office_cidr_blocks" {
  type = "list"

  default = [
    "0.0.0.0/0",
  ] # 이 값은 실제 접속을 허용할 IP를 넣어야 함
}

variable "keypair_name" {
  default = "2dal-dev"
}
