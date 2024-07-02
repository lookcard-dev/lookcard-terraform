resource "aws_dynamodb_table" "did_temp_storage_table" {
  name         = "did-temp-storage-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "recordId"

  attribute {
    name = "recordId"
    type = "S"
  }

  attribute {
    name = "method"
    type = "S"
  }

  attribute {
    name = "serializedData"
    type = "S"
  }

  global_secondary_index {
    name            = "gidx_1"
    hash_key        = "recordId"
    range_key       = "serializedData"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "gidx_0"
    hash_key        = "recordId"
    range_key       = "method"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "websocket" {
  name     = var.websoclet_table_name
  hash_key = "user_ID"
  attribute {
    name = "user_ID"
    type = "S"
  }
  billing_mode                = "PROVISIONED"
  read_capacity               = 5 # Specify a non-zero value for read capacity
  write_capacity              = 5 # Specify a non-zero value for write capacity
  deletion_protection_enabled = true
  point_in_time_recovery {
    enabled = true
  }
}


resource "aws_appautoscaling_target" "dynamodb_read" {
  #   count              = var.dynamodb_config.enable_autoscaling ? 1 : 0
  max_capacity       = 1000 # Maximum read capacity units
  min_capacity       = 5    # Minimum read capacity units
  resource_id        = "table/${aws_dynamodb_table.websocket.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_read" {
  count              = var.dynamodb_config.enable_autoscaling ? 1 : 0
  name               = "DynamoDBReadScalingPolicy:${aws_dynamodb_table.websocket.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_read.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_read.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 75.0
  }
}

resource "aws_appautoscaling_target" "dynamodb_write" {
  #   count              = var.dynamodb_config.enable_autoscaling ? 1 : 0
  max_capacity       = 1000 # Maximum write capacity units
  min_capacity       = 5    # Minimum write capacity units
  resource_id        = "table/${aws_dynamodb_table.websocket.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_write" {
  count              = var.dynamodb_config.enable_autoscaling ? 1 : 0
  name               = "DynamoDBWriteScalingPolicy:${aws_dynamodb_table.websocket.name}"
  policy_type        = "TargetTrackingScaling" # Specify the policy type
  resource_id        = aws_appautoscaling_target.dynamodb_write.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_write.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_dynamodb_table" "crypto-transaction-listener" {
  name           = "Crypto-Transaction-Listener-Block-Record"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "id"
  range_key      = "block_num"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "block_num"
    type = "N"
  }

}
