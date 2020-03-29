variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "sg_ids" {}

variable "sg_cidr_blocks" {}

variable "vpc_id" {}

variable "subnet_id" {}