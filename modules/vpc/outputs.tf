output "vpc_id" {
  value = aws_vpc.curis-vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.curis-vpc.cidr_block
}

output "subnet_id" {
  value = aws_subnet.curis-subnet.id
}

output "igw_id" {
  value = aws_internet_gateway.curis-igw.id
}

output "route_table_id" {
  value = aws_route_table.curis-route.id
}