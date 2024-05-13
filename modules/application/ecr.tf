resource "aws_ecr_repository" "look-card" {
  for_each             = var.ecr_names
  name                 = each.key
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecr_registry_scanning_configuration" "ecr_enhanced_scan_config" {
  scan_type = "ENHANCED"
  rule {
    scan_frequency = "CONTINUOUS_SCAN"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  depends_on = [aws_ecr_repository.look-card]

  for_each = var.ecr_names

  repository = each.key

  policy = <<EOF
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
