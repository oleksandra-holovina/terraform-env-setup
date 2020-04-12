variable "param-grp-name" {}

variable "param-grp-family" {}

variable "subnet-group-name" {}

variable "subnet_ids" {}

variable "vpc_id" {}

variable "sg-ids" {}

variable "sg-name" {}

variable "security-grps" {}

variable "allocated_storage" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "db-name" {}

variable "db-username" {}

variable "db-password" {}

variable "param-group-name" {}