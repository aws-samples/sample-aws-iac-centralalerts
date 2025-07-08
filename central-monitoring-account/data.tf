data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "org" {}

data "aws_s3_bucket" "selected" {
  bucket = var.code_signing_bucket_name
}
