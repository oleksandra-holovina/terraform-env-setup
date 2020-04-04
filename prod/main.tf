provider "aws" {
  profile = var.profile
  region  = var.region
}

module "curis-vpc" {
  source = "../modules/vpc"

  vpc_id   = module.curis-vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"

  subnet_id           = module.curis-vpc.subnet_id
  subnet_cidr         = "10.0.1.0/24"
  associate_public_ip = true
  availability_zone   = "us-east-2b"

  igw_id = module.curis-vpc.igw_id

  route_table_id   = module.curis-vpc.route_table_id
  route_table_cidr = "0.0.0.0/0"
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
  subnet_id = module.curis-vpc.subnet_id

  sg_ids         = module.curis-ec2.sg_ids
  sg_cidr_blocks = ["0.0.0.0/0"]

  cluster_name = module.curis-ecs.cluster_name
}


