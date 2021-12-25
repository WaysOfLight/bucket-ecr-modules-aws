module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.9.0"
  bucket  = "${var.project}-${var.environment}-images"
  acl     = "private"

  versioning = {
    enabled = true
  }
}