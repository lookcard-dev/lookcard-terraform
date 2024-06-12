# variable "private-subnet-1" {}
# variable "private-subnet-2" {}
# variable "private-subnet-3" {}
# variable "data_process_security_group" {}
# variable "eliptic_security_group" {}
# variable "push_notifi_security_group" {}
# variable "withdrawal_security_group" {}
# variable "pusd_noftifi_iam" {}
# variable "data_process_iam" {}
# variable "eliptic_iam" {}
# variable "push_web" {}
# variable "web_scoket_iam" {}
# variable "web_scoket_disconnect_iam" {}
# variable "withdrawal_iam" {}
# variable "isolated-subnet-1" {}
# variable "isolated-subnet-2" {}
# variable "Push_Message_web_security_group" {}
# variable "web_scoket_security_group" {}
# variable "web_scoket_disconnect_security_group" {}
# variable "Aggregator_Tron_sg" {}
variable "vpc_id" {}
variable "ddb_websocket_arn" {

}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "lambda_code" {
  type = object({
    s3_bucket                  = string
    websocket_connect_s3key    = string
    websocket_disconnect_s3key = string
    data_process_s3key         = string
    elliptic_s3key             = string
    push_message_s3key         = string
    push_notification_s3key    = string
    withdrawal_s3key           = string
  })
}

variable "secret_arn_list" {

}


data "aws_iam_policy_document" "lambda_sts_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
