resource "aws_iam_role" "sweep_processor_role" {
  name = "sweep-processor-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sweep_processor_sqs_send_message_policy" {
  name        = "SQSSendMessagePolicy"
  description = "Allows send message to SQS queue"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : aws_sqs_queue.sweep_processor_fifo_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sweep_processor_sqs_send_message_attachments" {
  role       = aws_iam_role.sweep_processor_role.name
  policy_arn = aws_iam_policy.sweep_processor_sqs_send_message_policy.arn
}

resource "aws_iam_role_policy_attachment" "sweep_processor_basic_executions" {
  role       = aws_iam_role.sweep_processor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sweep_processor_vpc_access" {
  role       = aws_iam_role.sweep_processor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}