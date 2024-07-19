resource "aws_iam_role" "xray_ecs_task_execution_role" {
  name = "xray_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_xray_policy" {
  name        = "ECSXRayPolicy"
  description = "Policy to allow ECS tasks to use X-Ray"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "servicediscovery:RegisterInstance",
          "servicediscovery:DeregisterInstance",
          "servicediscovery:DiscoverInstances",
          "ec2:DescribeNetworkInterfaces",
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "ec2:DescribeInstances"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.xray_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_xray_policy_attachment" {
  role       = aws_iam_role.xray_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_xray_policy.arn
}
