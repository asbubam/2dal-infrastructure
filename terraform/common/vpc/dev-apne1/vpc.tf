module "vpc" {
  source = "github.com/asbubam/2dal-infrastructure/terraform/modules/cheap_vpc"

  name = "dev-apne1"
  cidr = "10.0.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  bastion_ami                 = data.aws_ami.amazon_linux_nat.id
  bastion_availability_zone   = module.vpc.azs[0]
  bastion_subnet_id           = module.vpc.public_subnets_ids[0]
  bastion_ingress_cidr_blocks = ["0.0.0.0/0"]
  bastion_keypair_name        = "2dal-dev"

  tags = {
    "TerraformManaged" = "true"
  }
}
