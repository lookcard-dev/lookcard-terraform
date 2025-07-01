resource "aws_ecr_repository" "repository" {
  for_each             = var.components
  name                 = each.key
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Commenting out registry-level scanning configuration due to AWS provider inconsistency issues
# Individual repositories already have scan_on_push = true which provides the same functionality
# resource "aws_ecr_registry_scanning_configuration" "scanning_config" {
#   scan_type = "BASIC"
#   rule {
#     scan_frequency = "SCAN_ON_PUSH"
#     repository_filter {
#       filter      = "*"
#       filter_type = "WILDCARD"
#     }
#   }
# }

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  depends_on = [aws_ecr_repository.repository]
  for_each   = var.components
  repository = each.key
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
