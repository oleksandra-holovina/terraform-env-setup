resource "aws_kms_key" "curis-key" {
  description         = var.description
  enable_key_rotation = true
}

resource "aws_kms_alias" "curis-key-alias" {
  name          = var.alias
  target_key_id = aws_kms_key.curis-key.key_id
  depends_on    = [aws_kms_key.curis-key]
}