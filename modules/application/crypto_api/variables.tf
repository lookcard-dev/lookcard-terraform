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

# variable "ecs_security_groups" {}
# variable "vpc_id" {}