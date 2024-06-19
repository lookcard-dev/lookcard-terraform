variable "lookcardlocal_namespace_id" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "cluster" {}

variable "crypto_api_secret_arn" {}
variable "firebase_secret_arn" {}
variable "db_secret_secret_arn" {}

# variable "ecs_security_groups" {}
# variable "vpc_id" {}