resource "aws_nat_gateway" "dev_1a" {
  allocation_id = "${aws_eip.nat_dev_1a.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"
}

resource "aws_nat_gateway" "dev_1c" {
  allocation_id = "${aws_eip.nat_dev_1c.id}"
  subnet_id     = "${aws_subnet.public_1c.id}"
}
