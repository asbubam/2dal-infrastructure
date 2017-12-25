resource "aws_eip" "nat_dev_1a" {
  vpc = true
}

resource "aws_eip" "nat_dev_1c" {
  vpc = true
}
