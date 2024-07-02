
variable "vpc_id" {}
variable "aws_lb_listener_arn" {}
# variable "aws_lb_target_group_lookcard_tg_arn" {}

# variable "env" {}
# variable "Private-Subnet-1" {}

# variable "Private-Subnet-2" {}

# variable "Private-Subnet-3" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "iam_role" {}

# variable "subnet-pub-2" {}

# variable "subnet-pub-1" {}

# variable "ecs_security_groups" {}


# variable "ssl" {}

variable "cluster" {}
variable "sg_alb_id" {}
variable "sqs_withdrawal" {}

variable "env_secrets_arn" {}

variable "db_secret_secret_arn" {}

variable "token_secrets_arn" {}

# variable "alb_arn" {}

# variable "env" {}

# variable "cluster_name" {

# }





