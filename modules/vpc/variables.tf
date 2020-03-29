variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "associate_public_ip" {
  default = false
}

variable "availability_zone" {
  default = "us-east-2b"
}

variable "igw_id" {}

variable "route_table_id" {}

variable "route_table_cidr" {
  default = "0.0.0.0/0"
}

