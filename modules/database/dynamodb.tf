# DynamoDB 表: did_temp_storage_table
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

# DynamoDB 表: websocket，帶有自動調整配置
resource "aws_dynamodb_table" "websocket" {
  name     = var.websoclet_table_name
  hash_key = "user_ID"

  attribute {
    name = "user_ID"
    type = "S"
  }

  billing_mode                = "PROVISIONED"
  read_capacity               = 5
  write_capacity              = 5
  deletion_protection_enabled = true

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_appautoscaling_target" "dynamodb_read" {
  max_capacity       = 1000
  min_capacity       = 5
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
  max_capacity       = 1000
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.websocket.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_write" {
  count              = var.dynamodb_config.enable_autoscaling ? 1 : 0
  name               = "DynamoDBWriteScalingPolicy:${aws_dynamodb_table.websocket.name}"
  policy_type        = "TargetTrackingScaling"
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

# DynamoDB 表: crypto-transaction-listener
resource "aws_dynamodb_table" "crypto-transaction-listener" {
  name           = "Crypto_Transaction_Listener-Block_Record"
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

# DynamoDB 表: data-api-data-operation
resource "aws_dynamodb_table" "data_api_data_operation" {
  name           = "Data_API-Data_Operation"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "id"
  range_key      = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }
}

# DynamoDB 表: crypto-transaction-listener-transaction-record
resource "aws_dynamodb_table" "crypto_transaction_listener_transaction_record" {
  name           = "Crypto_Transaction_Listener-Transaction_Record"
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

# DynamoDB 表: config-api-config-data
resource "aws_dynamodb_table" "config_api_config_data" {
  name           = "Config_API-Config_Data"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

}

# DynamoDB 表: profile_data
resource "aws_dynamodb_table" "profile_data" {
  name         = "Profile_API-Profile_Data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "principal"
    type = "S"
  }

  global_secondary_index {
    name               = "principal-index"
    hash_key           = "principal"
    projection_type    = "ALL"
  }
}

# DynamoDB 表: data-api-data
resource "aws_dynamodb_table" "data_api_data" {
  name           = "Data_API-Data"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
