data "aws_availability_zones" "available" {}

variable "vpc_cidr" {}
variable "public_subnet_cidr_list" {}
variable "private_subnet_cidr_list" {}
variable "database_subnet_cidr_list" {}
variable "isolated_subnet_cidr_list" {}

variable "network_config" {
  type = object({
    replica_number  = optional(number)
    gateway_enabled = bool
  })
}
# variable "igw_name" {}

# variable "security_group_name" {}

# variable "route_table_name_private" {}

# variable "route_table_name_public" {}

# data "aws_availability_zones" "available" {}

# variable "aws_provider" {}

# variable "iam_role_arn" {}


# variable "log_bucket" {}


