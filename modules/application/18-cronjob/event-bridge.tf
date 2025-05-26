resource "aws_cloudwatch_event_rule" "monthly_batch_account_statement_generator" {
  # state               = var.image_tag == "latest" ? "DISABLED" : "ENABLED"
  state = "DISABLED"
  name                = "Monthly_Batch_Account_Statement_Generator"
  description         = "Triggers the batch account statement generator task every month at 7 AM"
  schedule_expression = "cron(0 7 1 * ? *)" # At 07:00 AM, on day 1 of every month
}

resource "aws_cloudwatch_event_target" "monthly_batch_account_statement_generator_ecs_target" {
  rule     = aws_cloudwatch_event_rule.monthly_batch_account_statement_generator.name
  arn      = var.cluster_id
  role_arn = aws_iam_role.event_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.batch_account_statement_generator_task_definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = var.network.private_subnet_ids
      security_groups  = [aws_security_group.security_group.id, var.external_security_group_ids.account_api]
      assign_public_ip = false
    }
  }
}

resource "aws_cloudwatch_event_rule" "daily_batch_account_snapshot_processor" {
  # state               = var.image_tag == "latest" ? "DISABLED" : "ENABLED"
  state = "DISABLED"
  name                = "Daily_Batch_Account_Snapshot_Processor"
  description         = "Triggers the daily batch account snapshot processor task every day at 1 AM"
  schedule_expression = "cron(0 1 * * ? *)" # At 01:00 AM, every day
}

resource "aws_cloudwatch_event_target" "daily_batch_account_snapshot_processor_ecs_target" {
  rule     = aws_cloudwatch_event_rule.daily_batch_account_snapshot_processor.name
  arn      = var.cluster_id
  role_arn = aws_iam_role.event_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.batch_account_snapshot_processor_task_definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = var.network.private_subnet_ids
      security_groups  = [aws_security_group.security_group.id, var.external_security_group_ids.account_api]
      assign_public_ip = false
    }
  }
}

resource "aws_cloudwatch_event_rule" "hourly_batch_retry_wallet_deposit_processor" {
  # state               = var.image_tag == "latest" ? "DISABLED" : "ENABLED"
  state = "DISABLED"
  name                = "Hourly_Batch_Retry_Wallet_Deposit_Processor"
  description         = "Triggers the hourly batch retry wallet deposit processor task every hour"
  schedule_expression = "cron(0 * * * ? *)" # At minute 0, every hour, every day
}

resource "aws_cloudwatch_event_target" "hourly_batch_retry_wallet_deposit_processor_ecs_target" {
  rule     = aws_cloudwatch_event_rule.hourly_batch_retry_wallet_deposit_processor.name
  arn      = var.cluster_id
  role_arn = aws_iam_role.event_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.batch_retry_wallet_deposit_processor_task_definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = var.network.private_subnet_ids
      security_groups  = [aws_security_group.security_group.id, var.external_security_group_ids.crypto_api]
      assign_public_ip = false
    }
  }
}

resource "aws_cloudwatch_event_rule" "hourly_batch_retry_wallet_withdrawal_processor" {
  state               = var.image_tag == "latest" ? "DISABLED" : "ENABLED"
  name                = "Hourly_Batch_Retry_Wallet_Withdrawal_Processor"
  description         = "Triggers the hourly batch retry wallet withdrawal processor task every hour"
  schedule_expression = "cron(0 * * * ? *)" # At minute 0, every hour, every day
}

resource "aws_cloudwatch_event_target" "hourly_batch_retry_wallet_withdrawal_processor_ecs_target" {
  rule     = aws_cloudwatch_event_rule.hourly_batch_retry_wallet_withdrawal_processor.name
  arn      = var.cluster_id
  role_arn = aws_iam_role.event_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.batch_retry_wallet_withdrawal_processor_task_definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = var.network.private_subnet_ids
      security_groups  = [aws_security_group.security_group.id, var.external_security_group_ids.crypto_api]
      assign_public_ip = false
    }
  }
}
