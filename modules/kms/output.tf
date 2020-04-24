output "kms-id" {
  value = aws_kms_key.curis-key.id
}

output "kms-arn" {
  value = aws_kms_key.curis-key.arn
}