resource "aws_db_parameter_group" "curis-db-param-grp" {
  name   = var.param-grp-name
  family = var.param-grp-family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "curis-db-subnet-grp" {
  name       = var.subnet-group-name
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "curis-db-sg" {
  vpc_id = var.vpc_id
  name   = var.sg-name

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = var.security-grps
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = {
    Name = "main-db-sg"
  }
}

resource "aws_db_instance" "curis-db-instance" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.db-name
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = var.param-group-name
  db_subnet_group_name   = var.subnet-group-name
  vpc_security_group_ids = var.sg-ids

  depends_on = [aws_db_subnet_group.curis-db-subnet-grp]
}