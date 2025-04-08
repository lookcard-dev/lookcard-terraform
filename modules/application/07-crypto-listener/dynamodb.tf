resource "aws_dynamodb_table" "block_recorder" {
  name         = "Crypto_Listener-Block_Recorder"
  billing_mode = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key     = "node"
  range_key    = "number"
  
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  attribute {
    name = "node"
    type = "S"
  }

  attribute {
    name = "number"
    type = "N"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
}

# Auto Scaling for block_recorder table
resource "aws_appautoscaling_target" "block_recorder_read_target" {
  max_capacity       = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 100 : 200
  min_capacity       = 10
  resource_id        = "table/${aws_dynamodb_table.block_recorder.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "block_recorder_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.block_recorder_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.block_recorder_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.block_recorder_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.block_recorder_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_target" "block_recorder_write_target" {
  max_capacity       = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 50 : 100
  min_capacity       = 10
  resource_id        = "table/${aws_dynamodb_table.block_recorder.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "block_recorder_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.block_recorder_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.block_recorder_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.block_recorder_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.block_recorder_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_dynamodb_table" "guard_recorder" {
  name         = "Crypto_Listener-Guard_Recorder"
  billing_mode = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key     = "node"

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  attribute {
    name = "node"
    type = "S"
  }
}
