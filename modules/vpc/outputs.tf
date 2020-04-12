output "vpc_id" {
  value = aws_vpc.curis-vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.curis-vpc.cidr_block
}

output "igw_id" {
  value = aws_internet_gateway.curis-igw.id
}