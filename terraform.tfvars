billing_code = "BC1"
project      = "web-app"

vpc_cidrblock = {
  default = "10.0.0.0/16"
  Development = "10.0.0.0/16"
  UAT = "10.1.0.0/16"
  Production = "10.2.0.0/16"
}

vpc_subnet_count = {
    default = 2
    Development = 2
    UAT = 2
    Production = 3
}

aws_instance_type = {
    default = "t2.micro"
    Development = "t2.micro"
    UAT = "t2.micro"
    Production = "t2.micro"
}

instance_count = {
    default = 2
    Development = 2
    UAT = 4
    Production = 6  
}