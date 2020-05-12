output "sg_ids" {
  value = [
    aws_security_group.curis_api_sg.id]
}

output "ec2_ip" {
  value = aws_instance.curis_api.public_ip
}
