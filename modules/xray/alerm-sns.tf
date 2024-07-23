resource "aws_cloudwatch_metric_alarm" "canary_failure_alarm" {
  alarm_name          = "CanaryFailureAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = 10  
  statistic           = "Average"
  threshold           = 100  # SuccessPercent < 100

  alarm_actions = [
    "arn:aws:sns:ap-southeast-1:471112511410:chatbot-critical-alert"
  ]

  dimensions = {
    CanaryName = aws_synthetics_canary.canary.name
  }

  depends_on = [aws_synthetics_canary.canary]
}
