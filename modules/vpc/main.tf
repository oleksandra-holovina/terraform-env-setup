resource "aws_vpc" "curis-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "curis-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "main-igw"
  }
}