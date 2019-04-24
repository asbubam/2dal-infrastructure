resource "aws_s3_bucket" "kops-state-local-k8s-2dal" {
  bucket = "kops-state-local-k8s-2dal"
  acl    = "private"

  versioning {
    enabled = true
  }
}
