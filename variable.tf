
variable "general_config" {
  type = object({
    env    = string
    domain = string
  })
}
variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "network" {
  type = object({
    vpc_cidr                  = string
    public_subnet_cidr_list   = list(string)
    private_subnet_cidr_list  = list(string)
    database_subnet_cidr_list = list(string)
    isolated_subnet_cidr_list = list(string)
  })
}
variable "s3_bucket" {
  type = object({
    ekyc_data          = string
    alb_log            = string
    cloudfront_log     = string
    vpc_flow_log       = string
    aml_code           = string
    front_end_endpoint = string
  })
}



variable "dns_config" {
  type = object({
    api_host_name   = string
    admin_host_name = string
    host_name       = string
  })
}

variable "ecs_cluster_config" {
  type = object({
    enable = bool
  })
}

