output "kms_id" {
  value = aws_kms_key.curis_key.id
}

output "kms_arn" {
  value = aws_kms_key.curis_key.arn
}