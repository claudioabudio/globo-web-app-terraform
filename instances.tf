# INSTANCES #
resource "aws_instance" "nginxs" {
  count                  = var.instance_count[terraform.workspace]
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_type[terraform.workspace]
  subnet_id              = module.vpc.public_subnets[count.index % var.vpc_subnet_count[terraform.workspace]]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  iam_instance_profile   = module.s3_bucket.ec2_instance_profile.name
  tags = merge({ Name = "${local.name_prefix}-nginx-${count.index}" },
  local.common_tags)
  depends_on = [
    module.s3_bucket
  ]

  user_data = templatefile("${path.module}/startup_script.tftpl",
    { s3_bucket_name = module.s3_bucket.bucket.id }
  )

}


