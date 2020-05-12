resource "aws_db_parameter_group" "curis_db_param_grp" {
  name   = var.param_grp_name
  family = var.param_grp_family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "curis_db_subnet_grp" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "curis_db_sg" {
  vpc_id = var.vpc_id
  name   = var.sg_name

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = var.security_grps
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "main-db-sg"
  }
}

resource "aws_db_instance" "curis_db_instance" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.param_group_name
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = var.sg_ids

  depends_on = [
    aws_db_subnet_group.curis_db_subnet_grp]
}