terraform {
  required_version = ">= 0.13.4"

  backend "s3" {
    bucket         = "2dal-infrastructure-tf-state"
    key            = "common/vpc/dev-apne2/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "2dal-infrastructure-tf-lock"
  }
}
