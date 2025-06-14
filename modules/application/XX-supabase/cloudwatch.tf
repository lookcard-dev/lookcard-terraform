# CloudWatch Log Groups for Supabase Services
resource "aws_cloudwatch_log_group" "gotrue_log_group" {
  name              = "/ecs/supabase/gotrue"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "supabase-gotrue-logs"
    Environment = var.runtime_environment
  }
}

resource "aws_cloudwatch_log_group" "postgrest_log_group" {
  name              = "/ecs/supabase/postgrest"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "supabase-postgrest-logs"
    Environment = var.runtime_environment
  }
}

resource "aws_cloudwatch_log_group" "postgres_meta_log_group" {
  name              = "/ecs/supabase/postgres-meta"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "supabase-postgres-meta-logs"
    Environment = var.runtime_environment
  }
}

resource "aws_cloudwatch_log_group" "kong_log_group" {
  name              = "/ecs/supabase/kong"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "supabase-postgres-meta-logs"
    Environment = var.runtime_environment
  }
}

resource "aws_cloudwatch_log_group" "realtime_log_group" {
  name              = "/ecs/supabase/realtime"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "supabase-realtime-logs"
    Environment = var.runtime_environment
  }
}

resource "aws_cloudwatch_log_group" "supabase_api_logs" {
  name              = "/aws/apigateway/supabase-api"
  retention_in_days = 14

  tags = {
    Name        = "supabase-api-logs"
    Environment = var.runtime_environment
  }
}
