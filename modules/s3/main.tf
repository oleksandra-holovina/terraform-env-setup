resource "aws_s3_bucket" "ssl_bucket" {
  bucket = "ssl"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.curis_kms_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}