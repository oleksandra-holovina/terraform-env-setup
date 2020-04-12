variable "availability_zone" {
  default = "us-east-2b"
}

variable "vpc_id" {}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "associate_public_ip" {
  default = false
}

variable "tag_name" {}
