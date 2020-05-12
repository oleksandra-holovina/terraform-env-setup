resource "aws_subnet" "curis_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.associate_public_ip

  tags = {
    Name = var.tag_name
  }
}