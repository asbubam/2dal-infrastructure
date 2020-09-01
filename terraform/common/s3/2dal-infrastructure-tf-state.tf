resource "aws_s3_bucket" "_2dal_infrastructure_tf_state" {
  bucket = "2dal-infrastructure-tf-state"
  acl    = "private"

  versioning {
    enabled = true
  }
}
