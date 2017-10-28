data "aws_ami" "amazon_linux" {
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
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
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
