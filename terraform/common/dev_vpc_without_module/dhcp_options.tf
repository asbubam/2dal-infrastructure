resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    Name = "default"
  }
}

resource "aws_vpc_dhcp_options_association" "dev_default" {
  vpc_id          = aws_vpc.dev.id
  dhcp_options_id = aws_default_vpc_dhcp_options.default.id
}
