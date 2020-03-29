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

resource "aws_subnet" "curis-subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = var.associate_public_ip

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_route_table" "curis-route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = var.igw_id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "curis-rt-association" {
  subnet_id = var.subnet_id
  route_table_id = var.route_table_id
}