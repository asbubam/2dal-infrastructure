resource "aws_dynamodb_table" "_2dal_infrastructure_tf_lock" {
  name           = "2dal-infrastructure-tf-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
