# bucket object
output "bucket" {
  value = aws_s3_bucket.web_bucket
}

# instance profile object
output "ec2_instance_profile" {
  value = aws_iam_instance_profile.nginx_ec2_profile
}
