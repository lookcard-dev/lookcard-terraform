data "aws_availability_zones" "available" {}

variable "network" {
  type = object({
    vpc_cidr                  = string
    public_subnet_cidr_list   = list(string)
    private_subnet_cidr_list  = list(string)
    database_subnet_cidr_list = list(string)
    isolated_subnet_cidr_list = list(string)
  })
}
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


