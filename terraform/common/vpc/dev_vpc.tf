module "vpc" {
  source = "github.com/asbubam/2dal-infrastructure/terraform/modules/cheap_vpc"

  name = "dev"
  cidr = "172.16.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.101.0/24", "172.16.102.0/24"]
  database_subnets = ["172.16.201.0/24", "172.16.202.0/24"]

  bastion_ami                 = "${data.aws_ami.amazon_linux_nat.id}"
  bastion_availability_zone   = "${module.vpc.azs[0]}"
  bastion_subnet_id           = "${module.vpc.public_subnets_ids[0]}"
  bastion_ingress_cidr_blocks = ["0.0.0.0/0"]
  bastion_keypair_name        = "2dal-dev"
  bastion_instance_profile    = "kops"

  tags = {
    "TerraformManaged"  = "true"
    "KubernetesCluster" = "2dal.k8s.local"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/2dal.k8s.local" = "owned"
    "kubernetes.io/role/elb"               = 1
    "SubnetType"                           = "Utility"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/2dal.k8s.local" = "owned"
    "kubernetes.io/role/internal-elb"      = 1
    "SubnetType"                           = "Private"
  }
}
