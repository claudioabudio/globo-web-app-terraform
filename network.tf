
##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "=3.10.0"
  name = "my-vpc"
  cidr = var.vpc_cidrblock

  azs             = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnet_count)
  public_subnets = [for i in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_cidrblock, 8, i)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-vpc" })
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidrblock]
  }

  # SSH access for troubleshooting 
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#  Load balancer security group 
resource "aws_security_group" "alb-sg" {
  name   = "nginx_alb_sg"
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



