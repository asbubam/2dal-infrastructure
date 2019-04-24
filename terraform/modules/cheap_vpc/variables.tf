variable "name" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = "string"
}

variable "cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = "string"
}

variable "public_subnets" {
  description = "Public Subnet IP 리스트"
  type        = "list"
}

variable "private_subnets" {
  description = "Private Subnet IP 리스트"
  type        = "list"
}

variable "database_subnets" {
  description = "Database Subnet IP 리스트"
  type        = "list"
}

variable "azs" {
  description = "사용할 availability zones 리스트"
  type        = "list"
}

variable "tags" {
  description = "모든 리소스에 추가되는 tag 맵"
  type        = "map"
}

variable "public_subnet_tags" {
  description = "public subnet에 추가되는 tag 맵"
  type        = "map"
  default     = {}
}

variable "private_subnet_tags" {
  description = "private subnet에 추가되는 tag 맵"
  type        = "map"
  default     = {}
}

variable "bastion_ami" {
  description = "bastion 생성에 사용할 AMI"
  type        = "string"
}

variable "bastion_instance_type" {
  description = "bastion EC2 instance type"
  default     = "t2.nano"
}

variable "bastion_availability_zone" {
  description = "bastion EC2 instance availability zone"
  type        = "string"
}

variable "bastion_subnet_id" {
  description = "bastion EC2 instance Subnet ID"
  type        = "string"
}

variable "bastion_keypair_name" {
  description = "bastion이 사용할 keypair name"
  type        = "string"
}

variable "bastion_ingress_cidr_blocks" {
  description = "bastion SSH 접속을 허용할 CIDR block 리스트"
  type        = "list"
}

variable "bastion_instance_profile" {
  description = "bastion 인스턴스에 할당할 instance profile"
  type        = "string"
  default     = ""
}
