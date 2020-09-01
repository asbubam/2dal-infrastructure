terraform {
  required_version = ">= 0.13.1"

  backend "s3" {
    bucket         = "2dal-infrastructure-tf-state"
    key            = "common/vpc/dev-apne1/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "2dal-infrastructure-tf-lock"
  }
}
