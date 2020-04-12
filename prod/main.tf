provider "aws" {
  profile = var.profile
  region  = var.region
}

module "curis-vpc" {
  source = "../modules/vpc"

  vpc_id   = module.curis-vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
}

module "curis-subnet-public" {
  source = "../modules/subnets"

  vpc_id              = module.curis-vpc.vpc_id
  subnet_cidr         = "10.0.0.0/24"
  associate_public_ip = true
  availability_zone   = "us-east-2a"
  tag_name            = "subnet-public"
}

module "curis-subnet-private-1" {
  source = "../modules/subnets"

  vpc_id              = module.curis-vpc.vpc_id
  subnet_cidr         = "10.0.1.0/24"
  associate_public_ip = false
  availability_zone   = "us-east-2a"
  tag_name            = "subnet-private-1"
}

module "curis-subnet-private-2" {
  source = "../modules/subnets"

  vpc_id              = module.curis-vpc.vpc_id
  subnet_cidr         = "10.0.2.0/24"
  associate_public_ip = false
  availability_zone   = "us-east-2b"
  tag_name            = "subnet-private-2"
}

module "curis-route-table" {
  source = "../modules/route_tables"

  vpc_id = module.curis-vpc.vpc_id
  igw_id = module.curis-vpc.igw_id

  route_table_id   = module.curis-route-table.route_table_id
  route_table_cidr = "0.0.0.0/0"

  subnet_id = module.curis-subnet-public.subnet_id
}

module "curis-ecs" {
  source = "../modules/ecs"
  name   = "main-cluster"
}

module "curis-ecr-frontend" {
  source = "../modules/ecr"
  name   = "curis-frontend"
}

module "curis-ecr-api" {
  source = "../modules/ecr"
  name   = "curis-api"
}

module "curis-ec2" {
  source = "../modules/ec2"

  ami_id        = "ami-044bf85e844eddde5"
  instance_type = "t2.micro"
  key_name      = "curis-api-key-pair"

  vpc_id    = module.curis-vpc.vpc_id
  subnet_id = module.curis-subnet-public.subnet_id

  sg_ids         = module.curis-ec2.sg_ids
  sg_cidr_blocks = ["0.0.0.0/0"]

  cluster_name = module.curis-ecs.cluster_name
}

data "aws_ssm_parameter" "curis-db-username" {
  name = "/config/curis-api/db.username"
}

data "aws_ssm_parameter" "curis-db-password" {
  name = "/config/curis-api/db.password"
}

module "curis-db" {
  source = "../modules/rds"

  param-grp-name   = "main-rds-grp"
  param-grp-family = "mysql8.0"

  subnet-group-name = "mysql-subnet-grp"
  subnet_ids        = [module.curis-subnet-private-1.subnet_id, module.curis-subnet-private-2.subnet_id]

  sg-name       = "main-db-sg"
  sg-ids        = [module.curis-db.sg-id]
  vpc_id        = module.curis-vpc.vpc_id
  security-grps = module.curis-ec2.sg_ids

  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.micro"
  db-name           = "curisnowdb"
  db-username       = data.aws_ssm_parameter.curis-db-username.value
  db-password       = data.aws_ssm_parameter.curis-db-password.value
  param-group-name  = module.curis-db.param-group-name
}

module "kms-db" {
  source = "../modules/kms"

  description = "Key to protect curis db"
  alias       = "alias/curis-db-key"
}