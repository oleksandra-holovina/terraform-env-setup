output "param_group_name" {
  value = aws_db_parameter_group.curis_db_param_grp.name
}

output "sg_id" {
  value = aws_security_group.curis_db_sg.id
}