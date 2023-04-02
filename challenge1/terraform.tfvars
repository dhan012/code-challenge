vpc_cidr_block = {
  Development = "10.0.0.0/16"
  UAT         = "10.1.0.0/16"
}

web_subnet_netnums_start = 0
app_subnet_netnums_start = 4
db_subnet_netnums_start  = 8

vpc_web_subnet_count = {
  Development = 2
  UAT         = 2
}

vpc_app_subnet_count = {
  Development = 2
  UAT         = 2
}

vpc_db_subnet_count = {
  Development = 2
  UAT         = 2
}

instance_type = {
  Development = "t2.micro"
  UAT         = "t2.micro"
}

web_instance_count = {
  Development = 1
  UAT         = 1
}

app_instance_count = {
  Development = 0
  UAT         = 1
}

db_instance_count = {
  Development = 0
  UAT         = 1
}

naming_prefix = "XYZproject"