output "param-group-name" {
  value = aws_db_parameter_group.curis-db-param-grp.name
}

output "sg-id" {
  value = aws_security_group.curis-db-sg.id
}