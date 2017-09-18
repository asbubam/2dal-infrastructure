resource "aws_default_security_group" "dev_default" {
  vpc_id = "${aws_vpc.dev.id}"

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

  tags {
    Name = "dev-default"
  }
}

resource "aws_security_group" "dev_docker_ephemeral_port_range" {
  name        = "dev_docker_ephemeral_port_range"
  description = "open docker ephemeral port range"
  vpc_id      = "${aws_vpc.dev.id}"

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 32768
    to_port   = 61000
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "dev-docker-ephemeral-port-range"
  }
}
