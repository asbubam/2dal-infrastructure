module "vpc" {
  source = "../../modules/vpc"

  name = "staging"
  cidr = "172.17.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["172.17.1.0/24", "172.17.2.0/24"]
  private_subnets  = ["172.17.101.0/24", "172.17.102.0/24"]
  database_subnets = ["172.17.201.0/24", "172.17.202.0/24"]

  tags = {
    "TerraformManaged" = "true"
  }
}
