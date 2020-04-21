output "sg_ids" {
  value = [aws_security_group.curis-api-sg.id]
}

output "ec2_ip" {
  value = aws_instance.curis-api.public_ip
}
