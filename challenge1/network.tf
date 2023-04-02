# Retrieve AZs
data "aws_availability_zones" "available" {}


# Networking
module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  name                    = var.name
  cidr                    = var.vpc_cidr_block[terraform.workspace]
  azs                     = slice(data.aws_availability_zones.available.names, 0, (var.vpc_web_subnet_count[terraform.workspace]))
  public_subnets          = [for subnet in range(var.vpc_web_subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, var.web_subnet_netnums_start + subnet)]
  private_subnets         = [for subnet in range(var.vpc_app_subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, var.app_subnet_netnums_start + subnet)]
  database_subnets        = [for subnet in range(var.vpc_db_subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, var.db_subnet_netnums_start + subnet)]
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  map_public_ip_on_launch = var.map_public_ip_on_launch
  database_subnet_tags = {
    type = "DB"
  }
  private_subnet_tags = {
    type = "app"
  }
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

# SGs
# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "${local.name_prefix}-nginx_alb_sg"
  vpc_id = module.vpc.vpc_id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# web  sg
resource "aws_security_group" "web_sg" {
  name   = "${local.name_prefix}-web_sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# app sg
resource "aws_security_group" "app_sg" {
  name   = "${local.name_prefix}-app_sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# db sg
resource "aws_security_group" "db_sg" {
  name   = "${local.name_prefix}-db_sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
