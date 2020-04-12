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
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}