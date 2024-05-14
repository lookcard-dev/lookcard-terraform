resource "aws_sns_topic" "alb_api_sns" {
  name              = "alb-api-alarm"
  kms_master_key_id = "aws/sns"
}

resource "aws_sns_topic" "rds_sns" {
  name              = "rds-alarm"
  kms_master_key_id = "aws/sns"
}

# resource "aws_sns_topic_subscription" "alb_health" {
#   for_each = {
#     for email in toset(var.sns_email) : email => [aws_sns_topic.alb_health_check.arn, aws_sns_topic.rds_sns.arn]
#   }
#   topic_arn = each.value[0]
#   protocol  = "email"
#   endpoint  = each.key
# }

# resource "aws_sns_topic_subscription" "RDS_SNS" {
#   for_each = toset(var.sns_email)

#   topic_arn = aws_sns_topic.rds_sns.arn
#   protocol  = "email"
#   endpoint  = each.value
# }
