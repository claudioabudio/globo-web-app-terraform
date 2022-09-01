# bucket name
variable "bucket_name" {
    type = string
    description = "Name of the s3 bucket to create"
}

# elb service account arn
variable "elb_service_account_arn" {
    type = string
    description = "arn of the elb service account"
}

# tags
variable "tags" {
    type = map(string)
    description = "map of tags"
    default = {}
}
