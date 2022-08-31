variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_cidrblock" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_subnet_count" {
  type    = number
  default = 2
}

variable "instance_count" {
  type    = number
  default = 2
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