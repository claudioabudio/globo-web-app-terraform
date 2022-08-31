output "aws_instance_public_dns" {
  value = aws_lb.nginx_lb.dns_name
}

output "s3_bucket_name" {
  value = local.s3_bucket_name
}