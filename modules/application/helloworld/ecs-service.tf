
# Create Task Definition
# resource "aws_ecs_task_definition" "example" {
#   family                   = "example-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256" # 0.25 vCPU
#   memory                   = "512" # 512 MiB
#   runtime_platform {
#     cpu_architecture        = "X86_64"
#     operating_system_family = "LINUX"
#   }

#   container_definitions = jsonencode([
#     {
#       name      = "hello-world-webapp"
#       image     = "dockerbogo/docker-nginx-hello-world"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     }
#   ])
# }

# # Create Security Group for the Service
# resource "aws_security_group" "example" {
#   name        = "ecs-sg"
#   description = "Allow inbound HTTP traffic"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create ECS Service
# resource "aws_ecs_service" "example" {
#   name            = "example-service"
#   cluster         = var.ecs_cluster_id
#   task_definition = aws_ecs_task_definition.example.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = var.private_subnet_list
#     security_groups = [aws_security_group.example.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.example.arn
#     container_name   = "hello-world-webapp"
#     container_port   = 80
#   }

# }

# Create Load Balancer

# resource "aws_lb_target_group" "example" {
  
#   name_prefix        = "tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.vpc_id

#   lifecycle {
#       create_before_destroy = true
#   }


# }


# resource "aws_lb_target_group_attachment" "example" {
#   target_group_arn = aws_lb_target_group.example.arn
#   target_id        = 
#   port             = 80
# }



# resource "aws_lb_listener" "example" {
#   load_balancer_arn = var.alb_arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.example.arn
#   }
# }
