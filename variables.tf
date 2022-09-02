variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_instance_type" {
  type    = map(string)
}

variable "vpc_cidrblock" {
  type    = map(string)
  description = "Base cidr block for the VPC"
}

variable "vpc_subnet_count" {
  type    = map(number)
}

variable "instance_count" {
  type    = map(number)
}

variable "http_port" {
  type    = number
  default = 80
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "company" {
  default = "Globomantics"
}

variable "project" {
}

variable "billing_code" {
}

variable "naming_prefix" {
  type        = string
  description = "naming prefix for all resources"
  default     = "globoweb"
}