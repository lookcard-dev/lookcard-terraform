

variable "network" {}

variable "alb_logging_bucket" {}

variable "domain" {}

variable "dns_config" {
  type = object({
    host_name       = string
    api_host_name   = string
    admin_host_name = string
  })
}

variable "ecs_cluster_config" {
  type = object({
    enable = bool
  })
}


variable "ecr_names" {
  description = "Map of ECR names"
  type        = map(string)
  default = {
    "authentication-api" = "authentication-api"
    "blockchain-api"     = "blockchain-api"
    "card-api"           = "card-api"
    "notification-api"   = "notification-api"
    "reporting-api"      = "reporting-api"
    "transaction-api"    = "transaction-api"
    "utility-api"        = "utility-api"
    "users-api"          = "users-api"
    "admin-panel-api"    = "admin-panel-api"
    "aml-tron"           = "aml-tron"
  }
}



# variable "Private-Subnet-1" {}

# variable "Private-Subnet-2" {}

# variable "Private-Subnet-3" {}

# variable "subnet-pub-2" {}

# variable "subnet-pub-1" {}

# variable "ecs_security_groups" {}

# variable "iam_role" {}

# variable "ssl" {}

# variable "alb_security_groups" {}

# variable "subnet-pub-3" {}

# variable "api_zone_id" {}

# variable "admin_panel_domain" {}

# variable "log_bucket" {}

# variable "env" {}

# variable "alb_waf" {}

# variable "admin_alb_waf" {}

# variable "admin_zone_id" {}

# variable "admin_panel_alb_security_group" {}
