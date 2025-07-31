# resource "aws_cloudwatch_event_rule" "reconciliation_hourly" {
#   name                = "lookcard-reconciliation-hourly-schedule"
#   description         = "Hourly reconciliation to fix authorization timeouts"
#   schedule_expression = "rate(1 hour)"

#   tags = {
#     Name        = "lookcard-reconciliation-hourly"
#     Environment = var.runtime_environment
#     Purpose     = "reconciliation-fix-authorization-timeouts"
#   }
# }

# data "aws_ecs_task_definition" "card_api" {
#   task_definition = "card-api"
# }

# resource "aws_cloudwatch_event_target" "reconciliation_hourly" {
#   rule      = aws_cloudwatch_event_rule.reconciliation_hourly.name
#   target_id = "reconciliation-hourly-ecs-target"
#   arn       = var.cluster_id
#   role_arn  = aws_iam_role.event_role.arn

#   ecs_target {
#     task_definition_arn = data.aws_ecs_task_definition.card_api.arn
#     task_count          = 1
#     launch_type         = "FARGATE"
#     platform_version    = "LATEST"
#   }

#   input = jsonencode({
#     containerOverrides = [
#       {
#         name = "reconciliation"
#         environment = [
#           {
#             name  = "RECONCILIATION_MODE"
#             value = "fix-only"
#           },
#           {
#             name  = "RECONCILIATION_FREQUENCY"
#             value = "hourly"
#           },
#           {
#             name  = "RECONCILIATION_HOURS_BACK"
#             value = "24"
#           },
#           {
#             name  = "EXECUTION_TRIGGER"
#             value = "event-bridge"
#           },
#           {
#             name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
#             value = aws_cloudwatch_log_group.app_hourly_reconciliation_job.name
#           },
#         ],
#         command = ["node", "dist/jobs/reconciliation.job.js"],
#         logConfiguration = {
#           logDriver = "awslogs"
#           options = {
#             "awslogs-group"         = "/ecs/cronjob/reconciliation/hourly"
#             "awslogs-region"        = var.aws_provider.region
#             "awslogs-stream-prefix" = "ecs"
#           }
#         }
#       }
#     ]
#   })
# }
