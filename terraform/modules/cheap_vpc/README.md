# VPC Module
VPC와 Public, Private Subnet Set를 생성하고 Bastion/NAT 겸용 EC2 인스턴스를 생성한다.

* 생성되는 리소스
    * VPC
    * VPC에서 사용할 Internet Gateway
    * VPC에서 사용할 Default NACL, Default Security Group
    * AZ 1개당 public, private, DB Subnet 각 1개
    * Internet Gateway, NAT Gateway에 Subnet을 연결하는 Route Table, Route Table Association 
    * Bastion (& NAT) instance

## Usage
```
module "vpc" {
  source = "github.com/asbubam/2dal-infrastructure/terraform/modules/cheap_vpc"

  name = "dev"
  cidr = "172.16.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.101.0/24", "172.16.102.0/24"]
  database_subnets = ["172.16.201.0/24", "172.16.202.0/24"]

  bastion_ami                 = "ami-12345"
  bastion_availability_zone   = "${module.vpc.azs[0]}"
  bastion_subnet_id           = "${module.vpc.public_subnets_ids[0]}"
  bastion_ingress_cidr_blocks = ["office ip CIDR"]
  bastion_keypair_name        = "keypar-name"

  tags = {
    "TerraformManaged" = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | 사용할 availability zones 리스트 | list | - | yes |
| bastion\_ami | bastion 생성에 사용할 AMI | string | - | yes |
| bastion\_availability\_zone | bastion EC2 instance availability zone | string | - | yes |
| bastion\_ingress\_cidr\_blocks | bastion SSH 접속을 허용할 CIDR block 리스트 | list | - | yes |
| bastion\_instance\_profile | bastion 인스턴스에 할당할 instance profile | string | `` | no |
| bastion\_instance\_type | bastion EC2 instance type | string | `t2.nano` | no |
| bastion\_keypair\_name | bastion이 사용할 keypair name | string | - | yes |
| bastion\_subnet\_id | bastion EC2 instance Subnet ID | string | - | yes |
| cidr | VPC에 할당한 CIDR block | string | - | yes |
| database\_subnets | Database Subnet IP 리스트 | list | - | yes |
| name | 모듈에서 정의하는 모든 리소스 이름의 prefix | string | - | yes |
| private\_subnet\_tags | private subnet에 추가되는 tag 맵 | map | `<map>` | no |
| private\_subnets | Private Subnet IP 리스트 | list | - | yes |
| public\_subnet\_tags | public subnet에 추가되는 tag 맵 | map | `<map>` | no |
| public\_subnets | Public Subnet IP 리스트 | list | - | yes |
| tags | 모든 리소스에 추가되는 tag 맵 | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| azs | VPC가 사용할 availability zones 리스트 |
| bastion_instance_id | Bastion EC2 instance ID |
| bastion_sg_id | Bastion에 접속하는 SG ID |
| database_subnet_group_ids | Database Subnet Group ID 리스트 |
| database_subnets_ids | Database Subnet ID 리스트 |
| default_network_acl_id | VPC default network ACL ID |
| default_security_group_id | VPC default Security Group ID |
| eip_id | Bastion에 할당된 EIP ID |
| igw_id | internet gateway |
| private_route_table_ids | Private Route Table ID 리스트 |
| private_subnets_ids | subnets |
| public_route_table_ids | route tables |
| public_subnets_ids | Public Subnet ID 리스트 |
| ssh_from_bastion_sg_id | Bastion을 통한 SSH 연결을 허용하는 SG ID |
| vpc_cidr_block | VPC에 할당한 CIDR block |
| vpc_id | VPC ID |
