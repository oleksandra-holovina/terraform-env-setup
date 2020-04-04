resource "aws_security_group" "curis-api-sg" {
  name        = "api-sg"
  description = "https, http, ssh"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_iam_role" "curis-role" {
  name = "curis-role"
  assume_role_policy = file("${path.module}/policies/aws_iam_role-policy.json")
}

resource "aws_iam_role_policy" "curis-role-policy" {
  name = "curis-role-policy"
  role = aws_iam_role.curis-role.id
  policy = file("${path.module}/policies/aws_iam_role_policy-policy.json")
}

resource "aws_iam_instance_profile" "curis-iam-instance" {
  name = "curis-iam-instance"
  role = aws_iam_role.curis-role.name
}

resource "aws_instance" "curis-api" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.sg_ids
  subnet_id = var.subnet_id
  key_name = var.key_name

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
EOF

  iam_instance_profile = aws_iam_instance_profile.curis-iam-instance.name

  tags = {
    Name = "api-instance"
  }
}