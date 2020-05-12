resource "aws_vpc" "curis_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "curis_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "main-igw"
  }
}