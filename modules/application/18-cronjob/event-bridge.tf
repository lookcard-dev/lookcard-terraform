resource "aws_cloudwatch_event_rule" "monthly_batch_account_statement_generator" {
  # state = var.image_tag == "latest" ? "DISABLED" : "ENABLED"
  state = "DISABLED"
  name                = "Monthly_Batch_Account_Statement_Generator"
  description         = "Triggers the batch account statement generator task every month at 7 AM"
  schedule_expression = "cron(0 7 1 * ? *)"  # At 07:00 AM, on day 1 of every month
}

resource "aws_cloudwatch_event_target" "monthly_batch_account_statement_generator_ecs_target" {
  rule      = aws_cloudwatch_event_rule.monthly_batch_account_statement_generator.name
  arn       = var.cluster_id
  role_arn  = aws_iam_role.event_role.arn

  ecs_target {
    task_count = 1
    task_definition_arn = aws_ecs_task_definition.batch_account_statement_generator_task_definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets         = var.network.private_subnet_ids
      security_groups = [aws_security_group.security_group.id, data.aws_security_group.account_api_security_group.id]
      assign_public_ip = false
    }
  }
}