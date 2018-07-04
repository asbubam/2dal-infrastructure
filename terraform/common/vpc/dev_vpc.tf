module "vpc" {
  source = "../../modules/vpc"

  name = "dev"
  cidr = "172.17.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["172.17.1.0/24", "172.17.2.0/24"]
  private_subnets  = ["172.17.101.0/24", "172.17.102.0/24"]
  database_subnets = ["172.17.201.0/24", "172.17.202.0/24"]

  tags = {
    "TerraformManaged" = "true"
  }
}

module "bastion" {
  source = "../../modules/bastion"

  name   = "dev"
  vpc_id = "${module.vpc.vpc_id}"

  ami                 = "${data.aws_ami.amazon_linux.id}"
  availability_zone   = "ap-northeast-1a"
  subnet_id           = "${module.vpc.public_subnets_ids[0]}"
  ingress_cidr_blocks = "${var.office_cidr_blocks}"
  keypair_name        = "${var.keypair_name}"

  tags = {
    "TerraformManaged" = "true"
  }
}
