resource "aws_iam_role" "instance_role" {
  name = "ecs-ec2-instance-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ec2.amazonaws.com",
        }
      }
    ]
  })
}

resource "aws_iam_policy" "instance_role_cloudwatch_policy" {
  name        = "CloudWatchPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "CloudWatchPolicy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.instance_role_cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ecs-ec2-instance-profile"
  role = aws_iam_role.instance_role.name
}