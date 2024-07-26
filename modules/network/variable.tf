data "aws_availability_zones" "available" {}
data "aws_ami" "nat_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-2018.03.0.20230404.0-x86_64-ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
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


