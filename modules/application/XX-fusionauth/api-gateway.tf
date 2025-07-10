# resource "aws_api_gateway_rest_api" "rest_api" {
#   name        = "fusionauth"
#   description = "API Gateway for FusionAuth"

#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# # Create /admin resource to block admin paths
# resource "aws_api_gateway_resource" "admin_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = "admin"
# }

# # Create /admin/* proxy resource to catch all admin sub-paths
# resource "aws_api_gateway_resource" "admin_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.admin_path.id
#   path_part   = "{proxy+}"
# }

# # Create /api resource for API management routes
# resource "aws_api_gateway_resource" "api_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = "api"
# }

# # Block /api/system/* - System management APIs
# resource "aws_api_gateway_resource" "api_system_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "system"
# }

# resource "aws_api_gateway_resource" "api_system_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_system_path.id
#   path_part   = "{proxy+}"
# }

# # Block /api/application/* - Application management APIs
# resource "aws_api_gateway_resource" "api_application_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "application"
# }

# resource "aws_api_gateway_resource" "api_application_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_application_path.id
#   path_part   = "{proxy+}"
# }

# # Block /api/tenant/* - Tenant management APIs
# resource "aws_api_gateway_resource" "api_tenant_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "tenant"
# }

# resource "aws_api_gateway_resource" "api_tenant_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_tenant_path.id
#   path_part   = "{proxy+}"
# }

# # Block /api/key/* - Key management APIs
# resource "aws_api_gateway_resource" "api_key_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "key"
# }

# resource "aws_api_gateway_resource" "api_key_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_key_path.id
#   path_part   = "{proxy+}"
# }

# # Block /api/lambda/* - Lambda management APIs
# resource "aws_api_gateway_resource" "api_lambda_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "lambda"
# }

# resource "aws_api_gateway_resource" "api_lambda_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_lambda_path.id
#   path_part   = "{proxy+}"
# }

# # Block /api/webhook/* - Webhook management APIs
# resource "aws_api_gateway_resource" "api_webhook_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "webhook"
# }

# resource "aws_api_gateway_resource" "api_webhook_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_webhook_path.id
#   path_part   = "{proxy+}"
# }

# # Block /admin with 403 Forbidden
# # resource "aws_api_gateway_method" "admin_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.admin_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /admin/* with 403 Forbidden
# # resource "aws_api_gateway_method" "admin_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.admin_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/system/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_system_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_system_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_system_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_system_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/application/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_application_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_application_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_application_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_application_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/tenant/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_tenant_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_tenant_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_tenant_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_tenant_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/key/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_key_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_key_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_key_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_key_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/lambda/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_lambda_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_lambda_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_lambda_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_lambda_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Block /api/webhook/* with 403 Forbidden
# # resource "aws_api_gateway_method" "api_webhook_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_webhook_path.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # resource "aws_api_gateway_method" "api_webhook_proxy_block" {
# #   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
# #   resource_id   = aws_api_gateway_resource.api_webhook_proxy.id
# #   http_method   = "ANY"
# #   authorization = "NONE"
# # }

# # Mock integration for /admin (returns 403)
# # resource "aws_api_gateway_integration" "admin_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_path.id
# #   http_method = aws_api_gateway_method.admin_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integration for /admin/* (returns 403)
# # resource "aws_api_gateway_integration" "admin_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_proxy.id
# #   http_method = aws_api_gateway_method.admin_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/system/*
# # resource "aws_api_gateway_integration" "api_system_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_system_path.id
# #   http_method = aws_api_gateway_method.api_system_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_system_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_system_proxy.id
# #   http_method = aws_api_gateway_method.api_system_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/application/*
# # resource "aws_api_gateway_integration" "api_application_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_application_path.id
# #   http_method = aws_api_gateway_method.api_application_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_application_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_application_proxy.id
# #   http_method = aws_api_gateway_method.api_application_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/tenant/*
# # resource "aws_api_gateway_integration" "api_tenant_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_tenant_path.id
# #   http_method = aws_api_gateway_method.api_tenant_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_tenant_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_tenant_proxy.id
# #   http_method = aws_api_gateway_method.api_tenant_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/key/*
# # resource "aws_api_gateway_integration" "api_key_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_key_path.id
# #   http_method = aws_api_gateway_method.api_key_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_key_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_key_proxy.id
# #   http_method = aws_api_gateway_method.api_key_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/lambda/*
# # resource "aws_api_gateway_integration" "api_lambda_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_lambda_path.id
# #   http_method = aws_api_gateway_method.api_lambda_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_lambda_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_lambda_proxy.id
# #   http_method = aws_api_gateway_method.api_lambda_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Mock integrations for /api/webhook/*
# # resource "aws_api_gateway_integration" "api_webhook_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_webhook_path.id
# #   http_method = aws_api_gateway_method.api_webhook_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # resource "aws_api_gateway_integration" "api_webhook_proxy_block_integration" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.api_webhook_proxy.id
# #   http_method = aws_api_gateway_method.api_webhook_proxy_block.http_method
# #   type        = "MOCK"
# # 
# #   request_templates = {
# #     "application/json" = jsonencode({
# #       statusCode = 403
# #     })
# #   }
# # }

# # Method response for /admin (403)
# # resource "aws_api_gateway_method_response" "admin_block_response" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_path.id
# #   http_method = aws_api_gateway_method.admin_block.http_method
# #   status_code = "403"
# # }

# # Method response for /admin/* (403)
# # resource "aws_api_gateway_method_response" "admin_proxy_block_response" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_proxy.id
# #   http_method = aws_api_gateway_method.admin_proxy_block.http_method
# #   status_code = "403"
# # }

# # Integration response for /admin (403)
# # resource "aws_api_gateway_integration_response" "admin_block_integration_response" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_path.id
# #   http_method = aws_api_gateway_method.admin_block.http_method
# #   status_code = "403"
# # 
# #   response_templates = {
# #     "application/json" = jsonencode({
# #       message = "Access to admin paths is forbidden"
# #     })
# #   }
# # 
# #   depends_on = [
# #     aws_api_gateway_method_response.admin_block_response,
# #     aws_api_gateway_integration.admin_block_integration
# #   ]
# # }

# # Integration response for /admin/* (403)
# # resource "aws_api_gateway_integration_response" "admin_proxy_block_integration_response" {
# #   rest_api_id = aws_api_gateway_rest_api.rest_api.id
# #   resource_id = aws_api_gateway_resource.admin_proxy.id
# #   http_method = aws_api_gateway_method.admin_proxy_block.http_method
# #   status_code = "403"
# # 
# #   response_templates = {
# #     "application/json" = jsonencode({
# #       message = "Access to admin paths is forbidden"
# #     })
# #   }
# # 
# #   depends_on = [
# #     aws_api_gateway_method_response.admin_proxy_block_response,
# #     aws_api_gateway_integration.admin_proxy_block_integration
# #   ]
# # }

# # Create allowed public API resources

# # /api/user/* - User registration and management
# resource "aws_api_gateway_resource" "api_user_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "user"
# }

# resource "aws_api_gateway_resource" "api_user_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_user_path.id
#   path_part   = "{proxy+}"
# }

# # /api/login - User login
# resource "aws_api_gateway_resource" "api_login_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "login"
# }

# # /api/logout - User logout
# resource "aws_api_gateway_resource" "api_logout_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "logout"
# }

# # /api/jwt/* - JWT token operations
# resource "aws_api_gateway_resource" "api_jwt_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "jwt"
# }

# resource "aws_api_gateway_resource" "api_jwt_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_jwt_path.id
#   path_part   = "{proxy+}"
# }

# # /api/passwordless/* - Passwordless authentication
# resource "aws_api_gateway_resource" "api_passwordless_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "passwordless"
# }

# resource "aws_api_gateway_resource" "api_passwordless_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_passwordless_path.id
#   path_part   = "{proxy+}"
# }

# # /api/two-factor/* - Two-factor authentication
# resource "aws_api_gateway_resource" "api_two_factor_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "two-factor"
# }

# resource "aws_api_gateway_resource" "api_two_factor_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_two_factor_path.id
#   path_part   = "{proxy+}"
# }

# # /api/status - Health check endpoint
# resource "aws_api_gateway_resource" "api_status_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.api_path.id
#   path_part   = "status"
# }

# # /oauth2/* - OAuth endpoints
# resource "aws_api_gateway_resource" "oauth2_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = "oauth2"
# }

# resource "aws_api_gateway_resource" "oauth2_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.oauth2_path.id
#   path_part   = "{proxy+}"
# }

# # /.well-known/* - Well-known endpoints for OAuth discovery
# resource "aws_api_gateway_resource" "well_known_path" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
#   path_part   = ".well-known"
# }

# resource "aws_api_gateway_resource" "well_known_proxy" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   parent_id   = aws_api_gateway_resource.well_known_path.id
#   path_part   = "{proxy+}"
# }

# # Methods and integrations for allowed paths

# # /api/user/* methods
# resource "aws_api_gateway_method" "api_user_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_user_path.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_user_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_user_proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # /api/login method
# resource "aws_api_gateway_method" "api_login_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_login_path.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# # /api/logout method
# resource "aws_api_gateway_method" "api_logout_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_logout_path.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# # /api/jwt/* methods
# resource "aws_api_gateway_method" "api_jwt_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_jwt_path.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_jwt_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # /api/passwordless/* methods
# resource "aws_api_gateway_method" "api_passwordless_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_passwordless_path.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_passwordless_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # /api/two-factor/* methods
# resource "aws_api_gateway_method" "api_two_factor_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_two_factor_path.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_two_factor_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # /api/status method
# resource "aws_api_gateway_method" "api_status_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_status_path.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# # /oauth2/* methods
# resource "aws_api_gateway_method" "oauth2_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.oauth2_path.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "oauth2_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.oauth2_proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # /.well-known/* methods
# resource "aws_api_gateway_method" "well_known_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.well_known_path.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "well_known_proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.well_known_proxy.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# # Integrations for allowed paths

# # /api/user/* integrations
# resource "aws_api_gateway_integration" "api_user_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_user_path.id
#   http_method             = aws_api_gateway_method.api_user_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/user"
# }

# resource "aws_api_gateway_integration" "api_user_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_user_proxy.id
#   http_method             = aws_api_gateway_method.api_user_proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/user/{proxy}"
# }

# # /api/login integration
# resource "aws_api_gateway_integration" "api_login_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_login_path.id
#   http_method             = aws_api_gateway_method.api_login_method.http_method
#   integration_http_method = "POST"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/login"
# }

# # /api/logout integration
# resource "aws_api_gateway_integration" "api_logout_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_logout_path.id
#   http_method             = aws_api_gateway_method.api_logout_method.http_method
#   integration_http_method = "POST"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/logout"
# }

# # /api/jwt/* integrations
# resource "aws_api_gateway_integration" "api_jwt_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_jwt_path.id
#   http_method             = aws_api_gateway_method.api_jwt_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/jwt"
# }

# resource "aws_api_gateway_integration" "api_jwt_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method             = aws_api_gateway_method.api_jwt_proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/jwt/{proxy}"
# }

# # /api/passwordless/* integrations
# resource "aws_api_gateway_integration" "api_passwordless_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_passwordless_path.id
#   http_method             = aws_api_gateway_method.api_passwordless_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/passwordless"
# }

# resource "aws_api_gateway_integration" "api_passwordless_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method             = aws_api_gateway_method.api_passwordless_proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/passwordless/{proxy}"
# }

# # /api/two-factor/* integrations
# resource "aws_api_gateway_integration" "api_two_factor_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_two_factor_path.id
#   http_method             = aws_api_gateway_method.api_two_factor_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/two-factor"
# }

# resource "aws_api_gateway_integration" "api_two_factor_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method             = aws_api_gateway_method.api_two_factor_proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/two-factor/{proxy}"
# }

# # /api/status integration
# resource "aws_api_gateway_integration" "api_status_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.api_status_path.id
#   http_method             = aws_api_gateway_method.api_status_method.http_method
#   integration_http_method = "GET"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/api/status"
# }

# # /oauth2/* integrations
# resource "aws_api_gateway_integration" "oauth2_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.oauth2_path.id
#   http_method             = aws_api_gateway_method.oauth2_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/oauth2"
# }

# resource "aws_api_gateway_integration" "oauth2_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.oauth2_proxy.id
#   http_method             = aws_api_gateway_method.oauth2_proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/oauth2/{proxy}"
# }

# # /.well-known/* integrations
# resource "aws_api_gateway_integration" "well_known_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.well_known_path.id
#   http_method             = aws_api_gateway_method.well_known_method.http_method
#   integration_http_method = "GET"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/.well-known"
# }

# resource "aws_api_gateway_integration" "well_known_proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.rest_api.id
#   resource_id             = aws_api_gateway_resource.well_known_proxy.id
#   http_method             = aws_api_gateway_method.well_known_proxy_method.http_method
#   integration_http_method = "GET"
#   type                    = "HTTP_PROXY"
#   connection_type         = "VPC_LINK"
#   connection_id           = var.api_gateway.vpc_link_id
#   uri                     = "http://auth.${var.domain.general.name}/.well-known/{proxy}"
# }

# # Method responses for allowed paths

# # /api/user/* method responses
# resource "aws_api_gateway_method_response" "api_user_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_path.id
#   http_method = aws_api_gateway_method.api_user_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "api_user_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_proxy.id
#   http_method = aws_api_gateway_method.api_user_proxy_method.http_method
#   status_code = "200"
# }

# # /api/login method response
# resource "aws_api_gateway_method_response" "api_login_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_login_path.id
#   http_method = aws_api_gateway_method.api_login_method.http_method
#   status_code = "200"
# }

# # /api/logout method response
# resource "aws_api_gateway_method_response" "api_logout_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_logout_path.id
#   http_method = aws_api_gateway_method.api_logout_method.http_method
#   status_code = "200"
# }

# # /api/jwt/* method responses
# resource "aws_api_gateway_method_response" "api_jwt_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_path.id
#   http_method = aws_api_gateway_method.api_jwt_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "api_jwt_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method = aws_api_gateway_method.api_jwt_proxy_method.http_method
#   status_code = "200"
# }

# # /api/passwordless/* method responses
# resource "aws_api_gateway_method_response" "api_passwordless_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_path.id
#   http_method = aws_api_gateway_method.api_passwordless_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "api_passwordless_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method = aws_api_gateway_method.api_passwordless_proxy_method.http_method
#   status_code = "200"
# }

# # /api/two-factor/* method responses
# resource "aws_api_gateway_method_response" "api_two_factor_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_path.id
#   http_method = aws_api_gateway_method.api_two_factor_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "api_two_factor_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method = aws_api_gateway_method.api_two_factor_proxy_method.http_method
#   status_code = "200"
# }

# # /api/status method response
# resource "aws_api_gateway_method_response" "api_status_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_status_path.id
#   http_method = aws_api_gateway_method.api_status_method.http_method
#   status_code = "200"
# }

# # /oauth2/* method responses
# resource "aws_api_gateway_method_response" "oauth2_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_path.id
#   http_method = aws_api_gateway_method.oauth2_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "oauth2_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_proxy.id
#   http_method = aws_api_gateway_method.oauth2_proxy_method.http_method
#   status_code = "200"
# }

# # /.well-known/* method responses
# resource "aws_api_gateway_method_response" "well_known_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_path.id
#   http_method = aws_api_gateway_method.well_known_method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_method_response" "well_known_proxy_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_proxy.id
#   http_method = aws_api_gateway_method.well_known_proxy_method.http_method
#   status_code = "200"
# }

# # Integration responses for allowed paths

# # /api/user/* integration responses
# resource "aws_api_gateway_integration_response" "api_user_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_path.id
#   http_method = aws_api_gateway_method.api_user_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_user_response,
#     aws_api_gateway_integration.api_user_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_user_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_proxy.id
#   http_method = aws_api_gateway_method.api_user_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_user_proxy_response,
#     aws_api_gateway_integration.api_user_proxy_integration
#   ]
# }

# # /api/login integration response
# resource "aws_api_gateway_integration_response" "api_login_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_login_path.id
#   http_method = aws_api_gateway_method.api_login_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_login_response,
#     aws_api_gateway_integration.api_login_integration
#   ]
# }

# # /api/logout integration response
# resource "aws_api_gateway_integration_response" "api_logout_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_logout_path.id
#   http_method = aws_api_gateway_method.api_logout_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_logout_response,
#     aws_api_gateway_integration.api_logout_integration
#   ]
# }

# # /api/jwt/* integration responses
# resource "aws_api_gateway_integration_response" "api_jwt_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_path.id
#   http_method = aws_api_gateway_method.api_jwt_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_jwt_response,
#     aws_api_gateway_integration.api_jwt_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_jwt_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method = aws_api_gateway_method.api_jwt_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_jwt_proxy_response,
#     aws_api_gateway_integration.api_jwt_proxy_integration
#   ]
# }

# # /api/passwordless/* integration responses
# resource "aws_api_gateway_integration_response" "api_passwordless_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_path.id
#   http_method = aws_api_gateway_method.api_passwordless_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_passwordless_response,
#     aws_api_gateway_integration.api_passwordless_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_passwordless_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method = aws_api_gateway_method.api_passwordless_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_passwordless_proxy_response,
#     aws_api_gateway_integration.api_passwordless_proxy_integration
#   ]
# }

# # /api/two-factor/* integration responses
# resource "aws_api_gateway_integration_response" "api_two_factor_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_path.id
#   http_method = aws_api_gateway_method.api_two_factor_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_two_factor_response,
#     aws_api_gateway_integration.api_two_factor_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_two_factor_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method = aws_api_gateway_method.api_two_factor_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_two_factor_proxy_response,
#     aws_api_gateway_integration.api_two_factor_proxy_integration
#   ]
# }

# # /api/status integration response
# resource "aws_api_gateway_integration_response" "api_status_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_status_path.id
#   http_method = aws_api_gateway_method.api_status_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.api_status_response,
#     aws_api_gateway_integration.api_status_integration
#   ]
# }

# # /oauth2/* integration responses
# resource "aws_api_gateway_integration_response" "oauth2_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_path.id
#   http_method = aws_api_gateway_method.oauth2_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.oauth2_response,
#     aws_api_gateway_integration.oauth2_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "oauth2_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_proxy.id
#   http_method = aws_api_gateway_method.oauth2_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.oauth2_proxy_response,
#     aws_api_gateway_integration.oauth2_proxy_integration
#   ]
# }

# # /.well-known/* integration responses
# resource "aws_api_gateway_integration_response" "well_known_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_path.id
#   http_method = aws_api_gateway_method.well_known_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.well_known_response,
#     aws_api_gateway_integration.well_known_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "well_known_proxy_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_proxy.id
#   http_method = aws_api_gateway_method.well_known_proxy_method.http_method
#   status_code = "200"

#   depends_on = [
#     aws_api_gateway_method_response.well_known_proxy_response,
#     aws_api_gateway_integration.well_known_proxy_integration
#   ]
# }

# # ====================================================================
# # CORS CONFIGURATION - OPTIONS Methods for All Allowed Endpoints
# # ====================================================================

# # CORS for /api/user/*
# resource "aws_api_gateway_method" "api_user_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_user_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_user_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_user_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/login
# resource "aws_api_gateway_method" "api_login_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_login_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/logout
# resource "aws_api_gateway_method" "api_logout_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_logout_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/jwt/*
# resource "aws_api_gateway_method" "api_jwt_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_jwt_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_jwt_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/passwordless/*
# resource "aws_api_gateway_method" "api_passwordless_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_passwordless_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_passwordless_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/two-factor/*
# resource "aws_api_gateway_method" "api_two_factor_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_two_factor_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "api_two_factor_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /api/status
# resource "aws_api_gateway_method" "api_status_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.api_status_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /oauth2/*
# resource "aws_api_gateway_method" "oauth2_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.oauth2_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "oauth2_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.oauth2_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # CORS for /.well-known/*
# resource "aws_api_gateway_method" "well_known_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.well_known_path.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "well_known_proxy_options" {
#   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
#   resource_id   = aws_api_gateway_resource.well_known_proxy.id
#   http_method   = "OPTIONS"
#   authorization = "NONE"
# }

# # ====================================================================
# # CORS Method Responses
# # ====================================================================

# # CORS method responses for /api/user/*
# resource "aws_api_gateway_method_response" "api_user_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_path.id
#   http_method = aws_api_gateway_method.api_user_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "api_user_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_proxy.id
#   http_method = aws_api_gateway_method.api_user_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/login
# resource "aws_api_gateway_method_response" "api_login_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_login_path.id
#   http_method = aws_api_gateway_method.api_login_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/logout
# resource "aws_api_gateway_method_response" "api_logout_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_logout_path.id
#   http_method = aws_api_gateway_method.api_logout_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/jwt/*
# resource "aws_api_gateway_method_response" "api_jwt_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_path.id
#   http_method = aws_api_gateway_method.api_jwt_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "api_jwt_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method = aws_api_gateway_method.api_jwt_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/passwordless/*
# resource "aws_api_gateway_method_response" "api_passwordless_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_path.id
#   http_method = aws_api_gateway_method.api_passwordless_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "api_passwordless_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method = aws_api_gateway_method.api_passwordless_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/two-factor/*
# resource "aws_api_gateway_method_response" "api_two_factor_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_path.id
#   http_method = aws_api_gateway_method.api_two_factor_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "api_two_factor_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method = aws_api_gateway_method.api_two_factor_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /api/status
# resource "aws_api_gateway_method_response" "api_status_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_status_path.id
#   http_method = aws_api_gateway_method.api_status_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /oauth2/*
# resource "aws_api_gateway_method_response" "oauth2_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_path.id
#   http_method = aws_api_gateway_method.oauth2_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "oauth2_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_proxy.id
#   http_method = aws_api_gateway_method.oauth2_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # CORS method responses for /.well-known/*
# resource "aws_api_gateway_method_response" "well_known_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_path.id
#   http_method = aws_api_gateway_method.well_known_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# resource "aws_api_gateway_method_response" "well_known_proxy_options_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_proxy.id
#   http_method = aws_api_gateway_method.well_known_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Max-Age"       = true
#   }
# }

# # ====================================================================
# # CORS Mock Integrations
# # ====================================================================

# # CORS mock integrations for /api/user/*
# resource "aws_api_gateway_integration" "api_user_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_path.id
#   http_method = aws_api_gateway_method.api_user_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "api_user_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_proxy.id
#   http_method = aws_api_gateway_method.api_user_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/login
# resource "aws_api_gateway_integration" "api_login_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_login_path.id
#   http_method = aws_api_gateway_method.api_login_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/logout
# resource "aws_api_gateway_integration" "api_logout_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_logout_path.id
#   http_method = aws_api_gateway_method.api_logout_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/jwt/*
# resource "aws_api_gateway_integration" "api_jwt_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_path.id
#   http_method = aws_api_gateway_method.api_jwt_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "api_jwt_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method = aws_api_gateway_method.api_jwt_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/passwordless/*
# resource "aws_api_gateway_integration" "api_passwordless_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_path.id
#   http_method = aws_api_gateway_method.api_passwordless_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "api_passwordless_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method = aws_api_gateway_method.api_passwordless_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/two-factor/*
# resource "aws_api_gateway_integration" "api_two_factor_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_path.id
#   http_method = aws_api_gateway_method.api_two_factor_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "api_two_factor_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method = aws_api_gateway_method.api_two_factor_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /api/status
# resource "aws_api_gateway_integration" "api_status_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_status_path.id
#   http_method = aws_api_gateway_method.api_status_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /oauth2/*
# resource "aws_api_gateway_integration" "oauth2_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_path.id
#   http_method = aws_api_gateway_method.oauth2_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "oauth2_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_proxy.id
#   http_method = aws_api_gateway_method.oauth2_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # CORS mock integrations for /.well-known/*
# resource "aws_api_gateway_integration" "well_known_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_path.id
#   http_method = aws_api_gateway_method.well_known_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# resource "aws_api_gateway_integration" "well_known_proxy_options_integration" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_proxy.id
#   http_method = aws_api_gateway_method.well_known_proxy_options.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = jsonencode({
#       statusCode = 200
#     })
#   }
# }

# # ====================================================================
# # CORS Integration Responses
# # ====================================================================

# # CORS integration responses for /api/user/*
# resource "aws_api_gateway_integration_response" "api_user_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_path.id
#   http_method = aws_api_gateway_method.api_user_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_user_options_response,
#     aws_api_gateway_integration.api_user_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_user_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_user_proxy.id
#   http_method = aws_api_gateway_method.api_user_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_user_proxy_options_response,
#     aws_api_gateway_integration.api_user_proxy_options_integration
#   ]
# }

# # CORS integration responses for /api/login
# resource "aws_api_gateway_integration_response" "api_login_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_login_path.id
#   http_method = aws_api_gateway_method.api_login_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_login_options_response,
#     aws_api_gateway_integration.api_login_options_integration
#   ]
# }

# # CORS integration responses for /api/logout
# resource "aws_api_gateway_integration_response" "api_logout_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_logout_path.id
#   http_method = aws_api_gateway_method.api_logout_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_logout_options_response,
#     aws_api_gateway_integration.api_logout_options_integration
#   ]
# }

# # CORS integration responses for /api/jwt/*
# resource "aws_api_gateway_integration_response" "api_jwt_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_path.id
#   http_method = aws_api_gateway_method.api_jwt_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_jwt_options_response,
#     aws_api_gateway_integration.api_jwt_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_jwt_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_jwt_proxy.id
#   http_method = aws_api_gateway_method.api_jwt_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_jwt_proxy_options_response,
#     aws_api_gateway_integration.api_jwt_proxy_options_integration
#   ]
# }

# # CORS integration responses for /api/passwordless/*
# resource "aws_api_gateway_integration_response" "api_passwordless_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_path.id
#   http_method = aws_api_gateway_method.api_passwordless_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_passwordless_options_response,
#     aws_api_gateway_integration.api_passwordless_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_passwordless_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_passwordless_proxy.id
#   http_method = aws_api_gateway_method.api_passwordless_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_passwordless_proxy_options_response,
#     aws_api_gateway_integration.api_passwordless_proxy_options_integration
#   ]
# }

# # CORS integration responses for /api/two-factor/*
# resource "aws_api_gateway_integration_response" "api_two_factor_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_path.id
#   http_method = aws_api_gateway_method.api_two_factor_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_two_factor_options_response,
#     aws_api_gateway_integration.api_two_factor_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "api_two_factor_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_two_factor_proxy.id
#   http_method = aws_api_gateway_method.api_two_factor_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_two_factor_proxy_options_response,
#     aws_api_gateway_integration.api_two_factor_proxy_options_integration
#   ]
# }

# # CORS integration responses for /api/status
# resource "aws_api_gateway_integration_response" "api_status_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.api_status_path.id
#   http_method = aws_api_gateway_method.api_status_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.api_status_options_response,
#     aws_api_gateway_integration.api_status_options_integration
#   ]
# }

# # CORS integration responses for /oauth2/*
# resource "aws_api_gateway_integration_response" "oauth2_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_path.id
#   http_method = aws_api_gateway_method.oauth2_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.oauth2_options_response,
#     aws_api_gateway_integration.oauth2_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "oauth2_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.oauth2_proxy.id
#   http_method = aws_api_gateway_method.oauth2_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,PUT,DELETE,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.oauth2_proxy_options_response,
#     aws_api_gateway_integration.oauth2_proxy_options_integration
#   ]
# }

# # CORS integration responses for /.well-known/*
# resource "aws_api_gateway_integration_response" "well_known_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_path.id
#   http_method = aws_api_gateway_method.well_known_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.well_known_options_response,
#     aws_api_gateway_integration.well_known_options_integration
#   ]
# }

# resource "aws_api_gateway_integration_response" "well_known_proxy_options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   resource_id = aws_api_gateway_resource.well_known_proxy.id
#   http_method = aws_api_gateway_method.well_known_proxy_options.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#     "method.response.header.Access-Control-Max-Age"       = "'86400'"
#   }

#   depends_on = [
#     aws_api_gateway_method_response.well_known_proxy_options_response,
#     aws_api_gateway_integration.well_known_proxy_options_integration
#   ]
# }

# # Deploy the API
# resource "aws_api_gateway_deployment" "deployment" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id

#   depends_on = [
#     # Block integrations
#     # aws_api_gateway_integration.admin_block_integration,
#     # aws_api_gateway_integration.admin_proxy_block_integration,
#     # aws_api_gateway_integration_response.admin_block_integration_response,
#     # aws_api_gateway_integration_response.admin_proxy_block_integration_response,
    
#     # API integrations
#     aws_api_gateway_integration.api_user_integration,
#     aws_api_gateway_integration.api_user_proxy_integration,
#     aws_api_gateway_integration.api_login_integration,
#     aws_api_gateway_integration.api_logout_integration,
#     aws_api_gateway_integration.api_jwt_integration,
#     aws_api_gateway_integration.api_jwt_proxy_integration,
#     aws_api_gateway_integration.api_passwordless_integration,
#     aws_api_gateway_integration.api_passwordless_proxy_integration,
#     aws_api_gateway_integration.api_two_factor_integration,
#     aws_api_gateway_integration.api_two_factor_proxy_integration,
#     aws_api_gateway_integration.api_status_integration,
#     aws_api_gateway_integration.oauth2_integration,
#     aws_api_gateway_integration.oauth2_proxy_integration,
#     aws_api_gateway_integration.well_known_integration,
#     aws_api_gateway_integration.well_known_proxy_integration,
    
#     # CORS integrations
#     aws_api_gateway_integration.api_user_options_integration,
#     aws_api_gateway_integration.api_user_proxy_options_integration,
#     aws_api_gateway_integration.api_login_options_integration,
#     aws_api_gateway_integration.api_logout_options_integration,
#     aws_api_gateway_integration.api_jwt_options_integration,
#     aws_api_gateway_integration.api_jwt_proxy_options_integration,
#     aws_api_gateway_integration.api_passwordless_options_integration,
#     aws_api_gateway_integration.api_passwordless_proxy_options_integration,
#     aws_api_gateway_integration.api_two_factor_options_integration,
#     aws_api_gateway_integration.api_two_factor_proxy_options_integration,
#     aws_api_gateway_integration.api_status_options_integration,
#     aws_api_gateway_integration.oauth2_options_integration,
#     aws_api_gateway_integration.oauth2_proxy_options_integration,
#     aws_api_gateway_integration.well_known_options_integration,
#     aws_api_gateway_integration.well_known_proxy_options_integration,
    
#     # CORS integration responses
#     aws_api_gateway_integration_response.api_user_options_integration_response,
#     aws_api_gateway_integration_response.api_user_proxy_options_integration_response,
#     aws_api_gateway_integration_response.api_login_options_integration_response,
#     aws_api_gateway_integration_response.api_logout_options_integration_response,
#     aws_api_gateway_integration_response.api_jwt_options_integration_response,
#     aws_api_gateway_integration_response.api_jwt_proxy_options_integration_response,
#     aws_api_gateway_integration_response.api_passwordless_options_integration_response,
#     aws_api_gateway_integration_response.api_passwordless_proxy_options_integration_response,
#     aws_api_gateway_integration_response.api_two_factor_options_integration_response,
#     aws_api_gateway_integration_response.api_two_factor_proxy_options_integration_response,
#     aws_api_gateway_integration_response.api_status_options_integration_response,
#     aws_api_gateway_integration_response.oauth2_options_integration_response,
#     aws_api_gateway_integration_response.oauth2_proxy_options_integration_response,
#     aws_api_gateway_integration_response.well_known_options_integration_response,
#     aws_api_gateway_integration_response.well_known_proxy_options_integration_response
#   ]

#   lifecycle {
#     create_before_destroy = true
#   }

#   triggers = {
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.admin_path.id,
#       aws_api_gateway_resource.admin_proxy.id,
#       aws_api_gateway_resource.api_user_path.id,
#       aws_api_gateway_resource.api_user_proxy.id,
#       aws_api_gateway_resource.api_login_path.id,
#       aws_api_gateway_resource.api_logout_path.id,
#       aws_api_gateway_resource.api_jwt_path.id,
#       aws_api_gateway_resource.api_jwt_proxy.id,
#       aws_api_gateway_resource.api_passwordless_path.id,
#       aws_api_gateway_resource.api_passwordless_proxy.id,
#       aws_api_gateway_resource.api_two_factor_path.id,
#       aws_api_gateway_resource.api_two_factor_proxy.id,
#       aws_api_gateway_resource.api_status_path.id,
#       aws_api_gateway_resource.oauth2_path.id,
#       aws_api_gateway_resource.oauth2_proxy.id,
#       aws_api_gateway_resource.well_known_path.id,
#       aws_api_gateway_resource.well_known_proxy.id,
#       # aws_api_gateway_method.admin_block.id,
#       # aws_api_gateway_method.admin_proxy_block.id,
#       aws_api_gateway_method.api_user_method.id,
#       aws_api_gateway_method.api_user_proxy_method.id,
#       aws_api_gateway_method.api_login_method.id,
#       aws_api_gateway_method.api_logout_method.id,
#       aws_api_gateway_method.api_jwt_method.id,
#       aws_api_gateway_method.api_jwt_proxy_method.id,
#       aws_api_gateway_method.api_passwordless_method.id,
#       aws_api_gateway_method.api_passwordless_proxy_method.id,
#       aws_api_gateway_method.api_two_factor_method.id,
#       aws_api_gateway_method.api_two_factor_proxy_method.id,
#       aws_api_gateway_method.api_status_method.id,
#       aws_api_gateway_method.oauth2_method.id,
#       aws_api_gateway_method.oauth2_proxy_method.id,
#       aws_api_gateway_method.well_known_method.id,
#       aws_api_gateway_method.well_known_proxy_method.id,
#       # aws_api_gateway_integration.admin_block_integration.id,
#       # aws_api_gateway_integration.admin_proxy_block_integration.id,
#       aws_api_gateway_integration.api_user_integration.id,
#       aws_api_gateway_integration.api_user_proxy_integration.id,
#       aws_api_gateway_integration.api_login_integration.id,
#       aws_api_gateway_integration.api_logout_integration.id,
#       aws_api_gateway_integration.api_jwt_integration.id,
#       aws_api_gateway_integration.api_jwt_proxy_integration.id,
#       aws_api_gateway_integration.api_passwordless_integration.id,
#       aws_api_gateway_integration.api_passwordless_proxy_integration.id,
#       aws_api_gateway_integration.api_two_factor_integration.id,
#       aws_api_gateway_integration.api_two_factor_proxy_integration.id,
#       aws_api_gateway_integration.api_status_integration.id,
#       aws_api_gateway_integration.oauth2_integration.id,
#       aws_api_gateway_integration.oauth2_proxy_integration.id,
#       aws_api_gateway_integration.well_known_integration.id,
#       aws_api_gateway_integration.well_known_proxy_integration.id,
#     ]))
#   }
# }

# # Create a custom domain name for API Gateway
# resource "aws_api_gateway_domain_name" "domain" {
#   domain_name     = "auth.${var.domain.general.name}"
#   certificate_arn = aws_acm_certificate.certificate.arn

#   depends_on = [
#     aws_acm_certificate.certificate,
#     aws_acm_certificate_validation.certificate_validation
#   ]
# }

# # Map the custom domain to the API Gateway stage
# resource "aws_api_gateway_base_path_mapping" "mapping" {
#   api_id      = aws_api_gateway_rest_api.rest_api.id
#   stage_name  = aws_api_gateway_stage.stage.stage_name
#   domain_name = aws_api_gateway_domain_name.domain.domain_name
#   depends_on = [
#     aws_api_gateway_domain_name.domain,
#     aws_api_gateway_stage.stage
#   ]
# }

# # Create stage
# resource "aws_api_gateway_stage" "stage" {
#   deployment_id        = aws_api_gateway_deployment.deployment.id
#   rest_api_id          = aws_api_gateway_rest_api.rest_api.id
#   stage_name           = var.runtime_environment
#   xray_tracing_enabled = true
#   access_log_settings {
#     destination_arn = aws_cloudwatch_log_group.api_access_log.arn
#     format = jsonencode({
#       requestId       = "$context.requestId"
#       userSub         = "$context.authorizer.claims.sub"
#       ip              = "$context.identity.sourceIp"
#       method          = "$context.httpMethod"
#       path            = "$context.path"
#       status          = "$context.status"
#       responseLength  = "$context.responseLength"
#       responseLatency = "$context.responseLatency"
#     })
#   }
#   depends_on = [
#     aws_api_gateway_deployment.deployment,
#     aws_cloudwatch_log_group.api_access_log,
#   ]
# }

# resource "aws_api_gateway_method_settings" "api" {
#   rest_api_id = aws_api_gateway_rest_api.rest_api.id
#   stage_name  = aws_api_gateway_stage.stage.stage_name
#   method_path = "*/*"
#   settings {
#     metrics_enabled = true
#     logging_level   = "INFO"
#   }
# }
