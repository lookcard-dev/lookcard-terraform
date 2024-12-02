variable "cluster" {}
variable "lookcardlocal_namespace" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

locals {
  application = {
    name      = "xray-daemon"
  }
  inbound_allow_sg_list = []
}
