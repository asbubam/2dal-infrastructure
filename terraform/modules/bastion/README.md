# Bastion Module
* Bastion instance, Security Group을 생성하는 모듈
* 생성되는 리소스
  * Bastion EC2 instance
  * Bastion EC2 instance에 할당되는 EIP
  * Bastion 에 접속하는 Security Group
  * Bastion 을 허용 하는 Security Group (Port:22)

## Usage
```
module "bastion" {
  source = "./modules/bastion"

  name   = "dev"
  vpc_id = "vpc-12345"

  ami                 = "ami-12345"
  availability_zone   = "ap-northeast-1a"
  subnet_id           = "subnet-12345"
  ingress_cidr_blocks = [10.0.0.0/24]
  keypair_name        = "keypair-name"

  tags = {
	TerraformManaged  = "true",
	Creator           = "bruce"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami | bastion 생성에 사용할 AMI | string | - | yes |
| availability_zone | bastion EC2 instance availability zone | string | - | yes |
| ingress_cidr_blocks | bastion SSH 접속을 허용할 CIDR block 리스트 | list | - | yes |
| instance_type | bastion EC2 instance type | string | `t2.nano` | no |
| keypair_name | bastion이 사용할 keypair name | string | - | yes |
| name | 모듈에서 정의하는 모든 리소스 이름의 prefix | string | - | yes |
| subnet_id | bastion EC2 instance Subnet ID | string | - | yes |
| tags | 모든 리소스에 추가되는 tag 맵 | map | - | yes |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_sg_id | Bastion에 접속하는 SG ID |
| eip_id | Bastion에 할당된 EIP ID |
| instance_id | Bastion EC2 instance ID |
| ssh_from_bastion_sg_id | Bastion을 통한 SSH 연결을 허용하는 SG ID |

