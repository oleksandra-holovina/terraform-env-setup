provider "aws" {
  profile = var.profile
  region  = var.region
}

module "curis_vpc" {
  source = "../modules/vpc"

  vpc_id   = module.curis_vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
}

module "curis_subnet_public" {
  source = "../modules/subnets"

  vpc_id              = module.curis_vpc.vpc_id
  subnet_cidr         = "10.0.0.0/24"
  associate_public_ip = true
  availability_zone   = "us-east-2a"
  tag_name            = "subnet-public"
}

module "curis_subnet_private_1" {
  source = "../modules/subnets"

  vpc_id              = module.curis_vpc.vpc_id
  subnet_cidr         = "10.0.1.0/24"
  associate_public_ip = false
  availability_zone   = "us-east-2a"
  tag_name            = "subnet-private-1"
}

module "curis_subnet_private_2" {
  source = "../modules/subnets"

  vpc_id              = module.curis_vpc.vpc_id
  subnet_cidr         = "10.0.2.0/24"
  associate_public_ip = false
  availability_zone   = "us-east-2b"
  tag_name            = "subnet-private-2"
}

module "curis-route-table" {
  source = "../modules/route_tables"

  vpc_id = module.curis_vpc.vpc_id
  igw_id = module.curis_vpc.igw_id

  route_table_id   = module.curis-route-table.route_table_id
  route_table_cidr = "0.0.0.0/0"

  subnet_id = module.curis_subnet_public.subnet_id
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

module "curis_ec2" {
  source = "../modules/ec2"

  ami_id        = "ami-044bf85e844eddde5"
  instance_type = "t2.micro"
  key_name      = "curis-api-key-pair"

  vpc_id    = module.curis_vpc.vpc_id
  subnet_id = module.curis_subnet_public.subnet_id

  sg_ids         = module.curis_ec2.sg_ids
  sg_cidr_blocks = [
    "0.0.0.0/0"]

  cluster_name = module.curis-ecs.cluster_name
}

module "curis_kms_db" {
  source = "../modules/kms"

  description = "Key to protect curis db"
  alias       = "alias/curis-db-key"
}

data "aws_ssm_parameter" "curis_db_username" {
  name = "/config/curis-api/db.username"
}

data "aws_ssm_parameter" "curis_db_password" {
  name = "/config/curis-api/db.password"
}

module "curis_db" {
  source = "../modules/rds"

  param_grp_name   = "main-rds-group"
  param_grp_family = "mysql8.0"

  subnet_group_name = "mysql-subnet-grp"
  subnet_ids        = [
    module.curis_subnet_private_1.subnet_id,
    module.curis_subnet_private_2.subnet_id]

  sg_name       = "main-db-sg"
  sg_ids        = [
    module.curis_db.sg_id]
  vpc_id        = module.curis_vpc.vpc_id
  security_grps = module.curis_ec2.sg_ids

  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.micro"
  db_name           = "curisnowdb"
  db_username       = data.aws_ssm_parameter.curis_db_username.value
  db_password       = data.aws_ssm_parameter.curis_db_password.value
  param_group_name  = module.curis_db.param_group_name
}

module "curis_route53" {
  source = "../modules/route53"

  domain_name = "curisnow.com"
  ec2_ip      = module.curis_ec2.ec2_ip
  ttl         = 300
  ns_records  = [
    "ns-27.awsdns-03.com",
    "ns-1037.awsdns-01.org",
    "ns-1779.awsdns-30.co.uk",
    "ns-762.awsdns-31.net"
  ]
}

resource "aws_route53_record" "curis_mx_record" {
  name    = module.curis_route53.curis_domain_name
  type    = "MX"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 1800

  records = [
    "10 inbound-smtp.us-east-1.amazonaws.com"
  ]
}

//resource "aws_route53_record" "curis_soa_record" {
//  name    = module.curis_route53.curis_domain_name
//  type    = "SOA"
//  zone_id = module.curis_route53.curis_zone_id
//  ttl     = 900
//
//  records = [
//    "ns-388.awsdns-48.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
//  ]ns-27.awsdns-03.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400
//}

resource "aws_route53_record" "curis_txt_ms_record" {
  name    = module.curis_route53.curis_domain_name
  type    = "TXT"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 3600

  records = [
    "MS=ms38320224"
  ]
}

resource "aws_route53_record" "curis_txt_amzn_record" {
  name    = "_amazonses.curisnow.com"
  type    = "TXT"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 1800

  records = [
    "WT2H1UaT17ObpHiGD9HtWvdI2755wEQf7XdnAEGIym0="
  ]
}

resource "aws_route53_record" "curis_cname_dk1_record" {
  name    = "a7w7zec3ygcwpolcn6lizzkctljmnutl._domainkey.curisnow.com"
  type    = "CNAME"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 1800

  records = [
    "a7w7zec3ygcwpolcn6lizzkctljmnutl.dkim.amazonses.com"
  ]
}

resource "aws_route53_record" "curis_cname_dk2_record" {
  name    = "epkmd7iatxbudybiyxbusqc6vhsfmyir._domainkey.curisnow.com"
  type    = "CNAME"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 1800

  records = [
    "epkmd7iatxbudybiyxbusqc6vhsfmyir.dkim.amazonses.com"
  ]
}

resource "aws_route53_record" "curis_cname_dk3_record" {
  name    = "lr5wl2gswatfleyv2u5z32qyefhlgieg._domainkey.curisnow.com"
  type    = "CNAME"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 1800

  records = [
    "lr5wl2gswatfleyv2u5z32qyefhlgieg.dkim.amazonses.com"
  ]
}

resource "aws_route53_record" "curis_cname_dk4_record" {
  name    = "_f4a5965caa8cf84a96e8f4fb267f647c.curisnow.com"
  type    = "CNAME"
  zone_id = module.curis_route53.curis_zone_id
  ttl     = 300

  records = [
    "96E112A3BF20C71B7CCB752403E392E4.CAF2ECA80F4084AC238E48AAA40B9923.5e9f8dfb9c64b.comodoca.com"
  ]
}

module "curis_s3_ssl" {
  source       = "../modules/s3"
  curis_kms_id = module.curis_kms_db.kms_arn
}