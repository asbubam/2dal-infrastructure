module "vpc" {
  source = "../../modules/vpc"

  name = "staging"
  cidr = "172.18.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["172.18.0.0/23", "172.18.2.0/23"]
  private_subnets  = ["172.18.4.0/23", "172.18.6.0/23"]
  database_subnets = ["172.18.8.0/23", "172.18.10.0/23"]

  tags = {
    "TerraformManaged"    = "true"
  }
}
