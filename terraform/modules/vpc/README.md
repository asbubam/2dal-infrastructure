# VPC Module
VPC와 Public, Private Subnet Set를 생성하는 모듈

* 생성되는 리소스
    * VPC
    * VPC에서 사용할 Internet Gateway
    * VPC에서 사용할 Default NACL, Default Security Group
    * AZ 1개당 public, private, DB Subnet 각 1개
    * AZ 1개당 NAT Gateway(EIP 적용) 1개
    * Internet Gateway, NAT Gateway에 Subnet을 연결하는 Route Table, Route Table Association 

## Usage
```
module "vpc" {
  source = "./modules/vpc"

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

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | 사용할 availability zones 리스트 | list | - | yes |
| cidr | VPC에 할당한 CIDR block | string | - | yes |
| database_subnets | Database Subnet IP 리스트 | list | - | yes |
| name | 모듈에서 정의하는 모든 리소스 이름의 prefix | string | - | yes |
| private_subnets | Private Subnet IP 리스트 | list | - | yes |
| public_subnets | Public Subnet IP 리스트 | list | - | yes |
| tags | 모든 리소스에 추가되는 tag 맵 | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| database_subnet_group_id | Database Subnet Group ID |
| database_subnets_ids | Database Subnet ID 리스트 |
| default_network_acl_id | VPC default network ACL ID |
| default_security_group_id | VPC default Security Group ID |
| igw_id | internet gateway |
| nat_ids | NAT gateway |
| nat_public_ips | NAT Gateway에 할당된 EIP 리스트 |
| natgw_ids | NAT Gateway ID 리스트 |
| private_route_table_ids | Private Route Table ID 리스트 |
| private_subnets_ids | subnets |
| public_route_table_ids | route tables |
| public_subnets_ids | Public Subnet ID 리스트 |
| vpc_cidr_block | VPC에 할당한 CIDR block |
| vpc_id | VPC ID |

