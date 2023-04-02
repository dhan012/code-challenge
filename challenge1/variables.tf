variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
}
variable "name" {
  type    = string
  default = "XYZproject"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr_block" {
  type        = map(string)
  description = "Base CIDR Block for VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = map(string)
  description = "Type for EC2 Instance"
}

variable "web_instance_count" {
  type        = map(number)
  description = "Number of instances to create in VPC"
  default = {
    "Development" = 1
  }
}
variable "app_instance_count" {
  type        = map(number)
  description = "Number of instances to create in VPC"
  default = {
    "Development" = 1
  }
}

variable "db_instance_count" {
  type        = map(number)
  description = "Number of instances to create in VPC"
  default = {
    "Development" = 1
  }
}

variable "database_subnet_group_name" {
  type    = string
  default = "db"
}
variable "web_subnet_netnums_start" {
  type        = number
  description = "subnet start number"
}
variable "app_subnet_netnums_start" {
  type        = number
  description = "subnet start number"
}
variable "db_subnet_netnums_start" {
  type        = number
  description = "subnet start number"
}
variable "vpc_web_subnet_count" {}
variable "vpc_app_subnet_count" {}
variable "vpc_db_subnet_count" {}
