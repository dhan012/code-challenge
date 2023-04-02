# Data

data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Resources

resource "aws_instance" "web_instance" {
  count                  = var.web_instance_count[terraform.workspace]
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type[terraform.workspace]
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_web_subnet_count[terraform.workspace])]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Hello ..</title></head><body">Hi There.!</body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

}

resource "aws_instance" "app_instance" {
  count                  = var.app_instance_count[terraform.workspace]
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type[terraform.workspace]
  subnet_id              = module.vpc.private_subnets[(count.index % var.vpc_app_subnet_count[terraform.workspace])]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data              = <<EOF
#! /bin/bash
# install some app tier
EOF

}
resource "aws_instance" "db_instance" {
  count                  = var.db_instance_count[terraform.workspace]
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type[terraform.workspace]
  subnet_id              = module.vpc.database_subnets[(count.index % var.vpc_db_subnet_count[terraform.workspace])]
  vpc_security_group_ids = [aws_security_group.db_sg.id]

}