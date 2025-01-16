data "aws_availability_zones" "available" {}

variable "network" {
  type = object({
    cidr = object({
      vpc = string
      subnets = object({
        public = list(string)
        private = list(string)
        database = list(string)
        isolated = list(string)
      })
    })
    nat = object({
      provider = string
      count = number
    })
  })
  validation {
    condition     = contains(["instance", "gateway"], var.network.nat.provider)
    error_message = "NAT provider must be either 'instance' or 'gateway'."
  }
}

variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}
# variable "network_config" {
#   type = object({
#     replica_number  = optional(number)
#     gateway_enabled = bool
#   })
# }
# variable "igw_name" {}

# variable "security_group_name" {}

# variable "route_table_name_private" {}

# variable "route_table_name_public" {}

# data "aws_availability_zones" "available" {}

# variable "aws_provider" {}

# variable "iam_role_arn" {}


# variable "log_bucket" {}


