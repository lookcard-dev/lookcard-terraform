resource "aws_iam_role" "lookcard_ecs_task_role" {
  name = "lookcard_ecstaskrole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    # Add tags if needed
  }
}

resource "aws_iam_role_policy_attachment" "lookcard_ecs_role" {
  role       = aws_iam_role.lookcard_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "lookcard_secrets_manager_read_policy" {
  name        = "lookcard-SecretsManagerReadOnlyPolicy"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:env-XDmFug"
      },
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:token-pvSXEu"
      },
      {
        "Sid" : "Statement2",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:db/secret-zkQPXo"
      },
      {
        "Sid" : "Statement3",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:aml_env-vKOhgi"
      }
    ]
  })
}




resource "aws_iam_policy_attachment" "lookcard_secrets_manager_read_attachment" {
  name       = "lookcard_SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.lookcard_ecs_task_role.name]
  policy_arn = aws_iam_policy.lookcard_secrets_manager_read_policy.arn
}

resource "aws_iam_policy" "lookcard_withdrawal_sqs_policy" {
  name        = "lookcard_sqs_access_withdrawal"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : "${var.sqs_withdrawal}"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "lookcard_withdrawal_sqs_attachment" {
  name       = "lookcard_SQSSendmessageAttachmentwithdrawal"
  roles      = [aws_iam_role.lookcard_ecs_task_role.name]
  policy_arn = aws_iam_policy.lookcard_withdrawal_sqs_policy.arn
}
