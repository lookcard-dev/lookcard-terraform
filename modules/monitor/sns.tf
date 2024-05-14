resource "aws_sns_topic" "alb_api_sns" {
  name              = "alb-api-alarm"
  kms_master_key_id = "aws/sns"
}
resource "aws_sns_topic_subscription" "alb_sns_topic_subscription" {
  for_each  = toset(var.sns_subscriptions_email)
  topic_arn = aws_sns_topic.alb_api_sns.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_sns_topic" "rds_sns" {
  name              = "rds-alarm"
  kms_master_key_id = "aws/sns"
}
resource "aws_sns_topic_subscription" "rds_sns_topic_subscription" {
  for_each  = toset(var.sns_subscriptions_email)
  topic_arn = aws_sns_topic.rds_sns.arn
  protocol  = "email"
  endpoint  = each.key
}

# resource "aws_sns_topic_subscription" "RDS_SNS" {
#   for_each = toset(var.sns_email)

#   topic_arn = aws_sns_topic.rds_sns.arn
#   protocol  = "email"
#   endpoint  = each.value
# }
