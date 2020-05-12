resource "aws_kms_key" "curis_key" {
  description         = var.description
  enable_key_rotation = true
}

resource "aws_kms_alias" "curis_key_alias" {
  name          = var.alias
  target_key_id = aws_kms_key.curis_key.key_id
  depends_on    = [
    aws_kms_key.curis_key]
}