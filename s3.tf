

# aws_s3_bucket_object
resource "aws_s3_bucket_object" "s3objects" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }
  bucket = module.s3_bucket.bucket.id
  key    = each.value
  source = ".${each.value}"
}

module "s3_bucket" {
  source = "./modules/globo-web-app-s3"
  bucket_name = local.s3_bucket_name
  tags = local.common_tags
  elb_service_account_arn = data.aws_elb_service_account.root.arn
}




