variable "param_grp_name" {}

variable "param_grp_family" {}

variable "subnet_group_name" {}

variable "subnet_ids" {}

variable "vpc_id" {}

variable "sg_ids" {}

variable "sg_name" {}

variable "security_grps" {}

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

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "param_group_name" {}