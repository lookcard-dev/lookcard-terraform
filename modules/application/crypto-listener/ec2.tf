data "aws_ssm_parameter" "ecs_optimized_bottlerocket_arm64_ami" {
  name = "/aws/service/bottlerocket/aws-ecs-2/arm64/latest/image_id"
}

data "aws_ssm_parameter" "ecs_optimized_bottlerocket_amd64_ami" {
  name = "/aws/service/bottlerocket/aws-ecs-2/x86_64/latest/image_id"
}

resource "aws_launch_template" "transaction_listener_arm64" {
  name                   = "ecs-transaction-listener-launch-template-arm64"
  instance_type          = "t4g.medium"
  image_id               = data.aws_ssm_parameter.ecs_optimized_bottlerocket_arm64_ami.value
  vpc_security_group_ids = [aws_security_group.transaction_listener_sg.id]

  user_data = filebase64("${path.module}/userdata.toml")

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs-instance-profile.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
        Name = "ecs-transaction-listener-instance-arm-64"
    }
  }
}

resource "aws_launch_template" "transaction_listener_amd64" {
  name                   = "ecs-transaction-listener-launch-template-amd64"
  instance_type          = "t3a.medium"
  image_id               = data.aws_ssm_parameter.ecs_optimized_bottlerocket_amd64_ami.value
  vpc_security_group_ids = [aws_security_group.transaction_listener_sg.id]

  user_data = filebase64("${path.module}/userdata.toml")

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs-instance-profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
        Name = "ecs-transaction-listener-instance-arm-64"
    }
  }
}

resource "aws_autoscaling_group" "transaction_listener_arm64" {
  min_size = 0
  max_size = 0

  name = "transaction-listener-arm64"

  launch_template {
    id = aws_launch_template.transaction_listener_arm64.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "ecs-transaction-listener-instance-arm-64"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "transaction_listener_amd64" {
  min_size = 1
  max_size = 1

  name = "transaction-listener-amd64"

  launch_template {
    id = aws_launch_template.transaction_listener_amd64.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "ecs-transaction-listener-instance-amd-64"
    propagate_at_launch = true
  }
}