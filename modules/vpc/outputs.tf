output "vpc_id" {
  value = aws_vpc.curis_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.curis_vpc.cidr_block
}

output "igw_id" {
  value = aws_internet_gateway.curis_igw.id
}