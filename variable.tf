variable "general_config" {
  type = object({
    env = string
  })
}
variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "s3_bucket" {
  type = object({
    ekyc_data      = string
    alb_log        = string
    front_end      = string
    cloudfront_log = string
    vpc_flow_log   = string
    aml_code       = string
  })
}

