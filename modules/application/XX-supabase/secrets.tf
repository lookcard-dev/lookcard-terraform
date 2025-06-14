locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string)

  # Construct database URL from DATABASE secret
  database_url = "postgresql://${local.db_secret.username}:${local.db_secret.password}@${local.db_secret.host}:${local.db_secret.port}/supabase?sslmode=require"
}

# Generate a static JWT secret for initial deployment
resource "random_password" "jwt_secret" {
  length  = 64
  special = false

  # Keep this stable across deployments
  lifecycle {
    ignore_changes = [length, special]
  }
}

# Create the SUPABASE secret with placeholder values
# These can be updated later with real JWTs once infrastructure is deployed
resource "aws_secretsmanager_secret_version" "supabase" {
  secret_id = var.secret_arns["SUPABASE"]
  secret_string = jsonencode({
    database_url     = local.database_url
    jwt_secret       = random_password.jwt_secret.result
    anon_key         = "PLACEHOLDER_ANON_KEY_${var.runtime_environment}_${substr(random_password.jwt_secret.result, 0, 8)}"
    service_role_key = "PLACEHOLDER_SERVICE_ROLE_KEY_${var.runtime_environment}_${substr(random_password.jwt_secret.result, 8, 8)}"
  })

  lifecycle {
    create_before_destroy = true
    # Only update if the database URL or JWT secret changes
    # This prevents unnecessary updates to the secret
    ignore_changes = [secret_string]
  }
}

# Output the secret ARN for reference
output "supabase_secret_arn" {
  value       = var.secret_arns["SUPABASE"]
  description = "ARN of the SUPABASE secret in AWS Secrets Manager"
}

# Output instructions for updating with real JWTs
output "jwt_update_instructions" {
  value       = <<-EOT
    # To update with real JWT tokens after deployment:
    # 1. Generate real JWT tokens using the JWT secret: ${substr(random_password.jwt_secret.result, 0, 16)}...
    # 2. Use AWS CLI or console to update the secret with real values:
    #    aws secretsmanager update-secret --secret-id ${var.secret_arns["SUPABASE"]} --secret-string '{"database_url":"...","jwt_secret":"...","anon_key":"real_jwt_here","service_role_key":"real_jwt_here"}'
  EOT
  description = "Instructions for updating the secret with real JWT tokens"
  sensitive   = true
}

/*
JavaScript snippet to generate real JWT tokens:

```javascript
const crypto = require('crypto');

// Get the JWT secret from Terraform output or AWS Secrets Manager
const JWT_SECRET = "your_64_char_jwt_secret_here";
const ENVIRONMENT = "${var.runtime_environment}";

function base64urlEncode(str) {
  return Buffer.from(str)
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');
}

function generateJWT(payload, secret) {
  const header = { alg: 'HS256', typ: 'JWT' };
  
  const encodedHeader = base64urlEncode(JSON.stringify(header));
  const encodedPayload = base64urlEncode(JSON.stringify(payload));
  
  const signature = crypto
    .createHmac('sha256', secret)
    .update(`$${encodedHeader}.$${encodedPayload}`)
    .digest('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');
  
  return `$${encodedHeader}.$${encodedPayload}.$${signature}`;
}

// Generate anon key
const anonPayload = {
  iss: 'supabase',
  ref: `lookcard-$${ENVIRONMENT}`,
  role: 'anon',
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60) // 1 year
};

// Generate service role key
const servicePayload = {
  iss: 'supabase',
  ref: `lookcard-$${ENVIRONMENT}`,
  role: 'service_role',
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60) // 1 year
};

const anonKey = generateJWT(anonPayload, JWT_SECRET);
const serviceRoleKey = generateJWT(servicePayload, JWT_SECRET);

console.log('Anon Key:', anonKey);
console.log('Service Role Key:', serviceRoleKey);

// Update AWS secret with generated tokens
const secretData = {
  database_url: "postgresql://...", // from existing secret
  jwt_secret: JWT_SECRET,
  anon_key: anonKey,
  service_role_key: serviceRoleKey
};

console.log('\\nAWS CLI command to update secret:');
console.log(`aws secretsmanager update-secret --secret-id ${var.secret_arns["SUPABASE"]} --secret-string '$${JSON.stringify(secretData)}'`);
```

Run with: node generate-jwt.js
*/
