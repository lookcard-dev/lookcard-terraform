resource "aws_ecs_cluster_capacity_providers" "administrative" {
  cluster_name       = aws_ecs_cluster.administrative.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 1 : 0
    weight            = var.runtime_environment == "production" ? 2 : 0
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 0 : 1
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "composite_application" {
  cluster_name       = aws_ecs_cluster.composite_application.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 1 : 0
    weight            = var.runtime_environment == "production" ? 2 : 0
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 0 : 1
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "core_application" {
  cluster_name       = aws_ecs_cluster.core_application.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 1 : 0
    weight            = var.runtime_environment == "production" ? 2 : 0
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    base              = var.runtime_environment == "production" ? 0 : 1
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cronjob" {
  cluster_name       = aws_ecs_cluster.cronjob.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = var.runtime_environment == "production" ? "FARGATE" : "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "listener" {
  cluster_name       = aws_ecs_cluster.listener.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT", "LISTENER_EC2_ARM64", "LISTENER_EC2_AMD64"]

  depends_on = [
    aws_ecs_capacity_provider.listener_arm64,
    aws_ecs_capacity_provider.listener_amd64
  ]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "LISTENER_EC2_AMD64"
  }
}

resource "aws_ecs_capacity_provider" "listener_arm64" {
  name = "LISTENER_EC2_ARM64"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.listener_arm64.arn
    managed_termination_protection = "ENABLED"
    managed_draining               = "ENABLED"
    managed_scaling {
      status                    = "ENABLED"
      instance_warmup_period    = 300
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
    }
  }
}

resource "aws_ecs_capacity_provider" "listener_amd64" {
  name = "LISTENER_EC2_AMD64"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.listener_amd64.arn
    managed_termination_protection = "ENABLED"
    managed_draining               = "ENABLED"
    managed_scaling {
      status                    = "ENABLED"
      instance_warmup_period    = 300
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
    }
  }
}

data "aws_ssm_parameter" "ecs_optimized_bottlerocket_arm64_ami" {
  name = "/aws/service/bottlerocket/aws-ecs-2/arm64/latest/image_id"
}

data "aws_ssm_parameter" "ecs_optimized_bottlerocket_amd64_ami" {
  name = "/aws/service/bottlerocket/aws-ecs-2/x86_64/latest/image_id"
}

resource "aws_launch_template" "listener_arm64" {
  name                   = "arm64"
  instance_type          = "t4g.small"
  image_id               = data.aws_ssm_parameter.ecs_optimized_bottlerocket_arm64_ami.value
  vpc_security_group_ids = [aws_security_group.ec2_cluster_security_group.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }
  credit_specification {
    cpu_credits = "standard"
  }
  # instance_market_options {
  #   market_type = var.runtime_environment == "production" ? null : "spot"
  # }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-listener-arm64"
    }
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 2
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    }
  }
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    }
  }

  user_data = base64encode(<<-EOT
    [settings.ecs]
    cluster = "${aws_ecs_cluster.listener.name}"
    EOT
  )

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_launch_template" "listener_amd64" {
  name                   = "amd64"
  instance_type          = "t3.small"
  image_id               = data.aws_ssm_parameter.ecs_optimized_bottlerocket_amd64_ami.value
  vpc_security_group_ids = [aws_security_group.ec2_cluster_security_group.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }
  credit_specification {
    cpu_credits = "standard"
  }
  # instance_market_options {
  #   market_type = var.runtime_environment == "production" ? null : "spot"
  # }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-listener-amd64"
    }
  }
  user_data = base64encode(<<-EOT
    [settings.ecs]
    cluster = "${aws_ecs_cluster.listener.name}"
    EOT
  )

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_autoscaling_group" "listener_arm64" {
  min_size              = 0
  max_size              = var.runtime_environment == "production" ? 12 : 6
  name                  = "listener-arm64"
  protect_from_scale_in = true
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = var.runtime_environment == "production" ? 50 : 0
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.listener_arm64.id
        version            = "$Latest"
      }
    }
  }
  vpc_zone_identifier = var.subnet_ids
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "listener_amd64" {
  min_size              = 0
  max_size              = var.runtime_environment == "production" ? 12 : 6
  name                  = "listener-amd64"
  protect_from_scale_in = true
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = var.runtime_environment == "production" ? 50 : 0
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.listener_amd64.id
        version            = "$Latest"
      }
      override {
        instance_type     = "t3.small"
        weighted_capacity = "1"
      }
      override {
        instance_type     = "t3a.small"
        weighted_capacity = "1"
      }
    }
  }
  vpc_zone_identifier = var.subnet_ids
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
