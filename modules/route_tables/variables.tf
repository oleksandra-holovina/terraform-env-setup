variable "route_table_id" {}

variable "route_table_cidr" {
  default = "0.0.0.0/0"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "igw_id" {}