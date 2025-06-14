locals {
  # Read the LATEST version of the SUPABASE secret (not the specific version created by Terraform)
  # This ensures Kong config updates automatically when JWT tokens are manually updated
  supabase_secret_data = jsondecode(data.aws_secretsmanager_secret_version.supabase.secret_string)

  # Extract JWT keys from the secret (these will be placeholders initially, real JWTs after manual update)
  supabase_anon_key         = local.supabase_secret_data.anon_key
  supabase_service_role_key = local.supabase_secret_data.service_role_key

  # Kong declarative configuration in YAML format matching official Supabase structure
  kong_declarative_config = yamlencode({
    _format_version = "2.1"
    _transform      = true

    ### Consumers / Users ###
    consumers = [
      {
        username = "DASHBOARD"
      },
      {
        username = "anon"
        keyauth_credentials = [
          {
            key = local.supabase_anon_key
          }
        ]
      },
      {
        username = "service_role"
        keyauth_credentials = [
          {
            key = local.supabase_service_role_key
          }
        ]
      }
    ]

    ### Access Control List ###
    acls = [
      {
        consumer = "anon"
        group    = "anon"
      },
      {
        consumer = "service_role"
        group    = "admin"
      }
    ]

    ### Dashboard credentials ###
    basicauth_credentials = [
      {
        consumer = "DASHBOARD"
        username = "admin"
        password = "admin123" # TODO: Make this configurable
      }
    ]

    ### API Routes ###
    services = [
      # Open Auth routes
      {
        name = "auth-v1-open"
        url  = "http://auth.supabase.lookcard.local:9999/verify"
        routes = [
          {
            name       = "auth-v1-open"
            strip_path = true
            paths      = ["/auth/v1/verify"]
            plugins = [
              {
                name = "cors"
              }
            ]
          }
        ]
      },
      {
        name = "auth-v1-open-callback"
        url  = "http://auth.supabase.lookcard.local:9999/callback"
        routes = [
          {
            name       = "auth-v1-open-callback"
            strip_path = true
            paths      = ["/auth/v1/callback"]
            plugins = [
              {
                name = "cors"
              }
            ]
          }
        ]
      },
      {
        name = "auth-v1-open-authorize"
        url  = "http://auth.supabase.lookcard.local:9999/authorize"
        routes = [
          {
            name       = "auth-v1-open-authorize"
            strip_path = true
            paths      = ["/auth/v1/authorize"]
            plugins = [
              {
                name = "cors"
              }
            ]
          }
        ]
      },
      # Secure Auth routes
      {
        name     = "auth-v1"
        _comment = "GoTrue: /auth/v1/* -> http://auth.supabase.lookcard.local:9999/*"
        url      = "http://auth.supabase.lookcard.local:9999/"
        routes = [
          {
            name       = "auth-v1-all"
            strip_path = true
            paths      = ["/auth/v1/"]
            plugins = [
              {
                name = "cors"
              },
              {
                name = "key-auth"
                config = {
                  hide_credentials = false
                }
              },
              {
                name = "acl"
                config = {
                  hide_groups_header = true
                  allow              = ["admin", "anon"]
                }
              }
            ]
          }
        ]
      },
      # Secure REST routes
      {
        name     = "rest-v1"
        _comment = "PostgREST: /rest/v1/* -> http://rest.supabase.lookcard.local:3000/*"
        url      = "http://rest.supabase.lookcard.local:3000/"
        routes = [
          {
            name       = "rest-v1-all"
            strip_path = true
            paths      = ["/rest/v1/"]
            plugins = [
              {
                name = "cors"
              },
              {
                name = "key-auth"
                config = {
                  hide_credentials = true
                }
              },
              {
                name = "acl"
                config = {
                  hide_groups_header = true
                  allow              = ["admin", "anon"]
                }
              }
            ]
          }
        ]
      },
      # Secure GraphQL routes
      {
        name     = "graphql-v1"
        _comment = "PostgREST: /graphql/v1/* -> http://rest.supabase.lookcard.local:3000/rpc/graphql"
        url      = "http://rest.supabase.lookcard.local:3000/rpc/graphql"
        routes = [
          {
            name       = "graphql-v1-all"
            strip_path = true
            paths      = ["/graphql/v1"]
            plugins = [
              {
                name = "cors"
              },
              {
                name = "key-auth"
                config = {
                  hide_credentials = true
                }
              },
              {
                name = "request-transformer"
                config = {
                  add = {
                    headers = ["Content-Profile:graphql_public"]
                  }
                }
              },
              {
                name = "acl"
                config = {
                  hide_groups_header = true
                  allow              = ["admin", "anon"]
                }
              }
            ]
          }
        ]
      },
      # Secure Database routes
      {
        name     = "meta"
        _comment = "pg-meta: /pg/* -> http://meta.supabase.lookcard.local:8080/*"
        url      = "http://meta.supabase.lookcard.local:8080/"
        routes = [
          {
            name       = "meta-all"
            strip_path = true
            paths      = ["/pg/"]
            plugins = [
              {
                name = "key-auth"
                config = {
                  hide_credentials = false
                }
              },
              {
                name = "acl"
                config = {
                  hide_groups_header = true
                  allow              = ["admin"]
                }
              }
            ]
          }
        ]
      }

      # NOTE: Studio (Dashboard) runs on App Runner with its own domain:
      # https://studio.supabase.{domain.admin.name}
      # It's not routed through Kong API Gateway

      # TODO: Add these services when implemented:
      # - Realtime (WebSocket and REST API for real-time features)
      # - Storage (File storage and management)
      # - Edge Functions (Serverless functions)
      # - Analytics (Usage analytics and monitoring)
    ]
  })
}

# Store Kong configuration in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "kong_config" {
  name        = "/supabase/kong/config"
  description = "Kong declarative configuration for Supabase"
  type        = "String"
  value       = local.kong_declarative_config

  # Ensure this runs after the secret is created, but will update when secret content changes
  depends_on = [aws_secretsmanager_secret_version.supabase]

  tags = {
    Name    = "kong-config"
    Service = "supabase-kong"
  }
}

# Output the configuration for reference
output "kong_config_yaml" {
  value       = local.kong_declarative_config
  description = "Kong declarative configuration in YAML format"
  sensitive   = true
}

output "kong_config_parameter_name" {
  value       = aws_ssm_parameter.kong_config.name
  description = "SSM Parameter name containing Kong configuration"
}

# Output Kong config status for debugging
output "kong_jwt_keys_status" {
  value = {
    anon_key_is_placeholder         = startswith(local.supabase_anon_key, "PLACEHOLDER_")
    service_role_key_is_placeholder = startswith(local.supabase_service_role_key, "PLACEHOLDER_")
    anon_key_length                 = length(local.supabase_anon_key)
    service_role_key_length         = length(local.supabase_service_role_key)
  }
  description = "Status of JWT keys in Kong configuration"
}
