variable "acm" {}
variable "application" {}

variable "env_tag" {}
variable "dns_config" {}
variable "domain" {}

variable "methods" {
  type    = list(string)
  default = ["GET", "POST", "PUT"]  # List of HTTP methods
}

variable "reseller_api_root_resource" {
  type    = list(string)
  default = ["reseller", "resellers"]
}