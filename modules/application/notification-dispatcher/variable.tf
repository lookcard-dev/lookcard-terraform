variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "sqs" {}
variable "secret_manager" {}

locals {
    lambda_env_vars = {
      "FROM_EMAIL"     = "no-reply@lookcard.io"
      "APP_NAME"       = "LOOKCARD"
      "AWS_SECRET_ARN" = "${var.secret_manager.notification_env_secret_arn}"
    }
    secrets = [
      var.secret_manager.notification_env_secret_arn
    ]
}

