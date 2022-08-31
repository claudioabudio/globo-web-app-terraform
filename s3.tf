# aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  acl           = "private"
  force_destroy = true
  tags          = local.common_tags

  versioning {
    enabled = false
  }

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.root.arn}"
        ]
      }
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Condition": {
            "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
            }
        }
    },
    {
         "Action": [
        "s3:GetBucketAcl"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# aws_s3_bucket_object
resource "aws_s3_bucket_object" "s3objects" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value
  source = ".${each.value}"
}

# aws_iam_role
resource "aws_iam_role" "nginx_s3_role" {
  name = "nginx_s3_role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.common_tags
}


# aws_iam_role_policy
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.nginx_s3_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      },
    ]
  })
}



# aws_iam_instance_profile
resource "aws_iam_instance_profile" "nginx_ec2_profile" {
  name = "nginx_ec2_profile"
  role = aws_iam_role.nginx_s3_role.name
  tags = local.common_tags
}