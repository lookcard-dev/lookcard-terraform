# Create a dedicated Supabase namespace within the main private DNS namespace


# Cloud Map Service Discovery for GoTrue (Auth Service)
resource "aws_service_discovery_service" "gotrue" {
  name = "auth.supabase"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "supabase-auth"
    Environment = var.runtime_environment
  }
}

# Cloud Map Service Discovery for PostgREST (REST API)
resource "aws_service_discovery_service" "postgrest" {
  name = "rest.supabase"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "supabase-rest"
    Environment = var.runtime_environment
  }
}

# Cloud Map Service Discovery for Postgres Meta (Database Management)
resource "aws_service_discovery_service" "postgres_meta" {
  name = "meta.supabase"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "supabase-meta"
    Environment = var.runtime_environment
  }
}

# Cloud Map Service Discovery for Kong (API Gateway)
resource "aws_service_discovery_service" "kong" {
  name = "kong.supabase"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "supabase-kong"
    Environment = var.runtime_environment
  }
}
