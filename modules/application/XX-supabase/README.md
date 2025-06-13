# Supabase Self-Hosted Stack - Complete Setup with Admin Panel

This module deploys a complete Supabase stack on AWS ECS, including the admin dashboard (Studio).

## 🏗️ Architecture Overview

This deployment includes **4 core services**:

1. **GoTrue (Auth)** - Authentication & user management (Port 9999)
2. **PostgREST (REST)** - Auto-generated REST API (Port 3000)
3. **Postgres Meta** - Database management API (Port 8080)
4. **Studio (Admin)** - Web dashboard for administration (Port 3000)

## 🌐 Domain Configuration

### Public Endpoints

- **Auth API**: `https://auth.${var.domain.general.name}`
  - User authentication, signup, signin, password reset
  - JWT token management

### Admin Endpoints

- **Admin Dashboard**: `https://supabase.${var.domain.admin.name}`
  - Complete Supabase Studio interface
  - User management, database browser, SQL editor
  - Real-time monitoring and logs

## 🚀 Services Included

### ✅ GoTrue (Authentication)

- **Image**: `supabase/gotrue:v2.176.1`
- **Port**: 9999
- **Features**:
  - JWT-based authentication
  - User signup/signin/password reset
  - Email confirmation flows
  - OAuth provider support (configurable)
  - Rate limiting and security features

### ✅ PostgREST (REST API)

- **Image**: `postgrest/postgrest:v12.2.3`
- **Port**: 3000
- **Features**:
  - Auto-generated REST API from your PostgreSQL schema
  - Row Level Security integration
  - JWT authentication with GoTrue
  - Schema: `public,auth`

### ✅ Postgres Meta (Database Management)

- **Image**: `supabase/postgres-meta:v0.84.2`
- **Port**: 8080
- **Features**:
  - Database schema introspection
  - Table/column management APIs
  - Used by Studio for database operations

### ✅ Studio (Admin Dashboard)

- **Image**: `supabase/studio:20241029-46e1e40`
- **Port**: 3000
- **Features**:
  - Complete web-based admin interface
  - User management and authentication logs
  - Database browser with SQL editor
  - Real-time data viewer
  - API documentation generator

## 🔐 Required Secrets in AWS Secrets Manager

### `DATABASE` Secret

The following keys must be present in your DATABASE secret:

```json
{
	"host": "your-postgres-host",
	"port": "5432",
	"dbname": "your-database-name",
	"username": "postgres-username",
	"password": "postgres-password",
	"supabase_database_url": "postgresql://username:password@host:port/dbname"
}
```

### `SUPABASE` Secret

```json
{
	"jwt_secret": "your-super-secret-jwt-key-min-32-chars",
	"anon_key": "generated-anon-key-using-jwt-secret",
	"service_role_key": "generated-service-role-key-using-jwt-secret",
	"site_url": "https://your-frontend-app.com",
	"uri_allow_list": "https://your-frontend-app.com,https://localhost:3000"
}
```

### `SMTP` Secret

```json
{
	"host": "smtp.your-provider.com",
	"port": "587",
	"username": "smtp-username",
	"password": "smtp-password",
	"admin_email": "admin@your-domain.com"
}
```

### `SENTRY` Secret (Optional)

```json
{
	"SUPABASE_DSN": "https://your-sentry-dsn@sentry.io/project-id"
}
```

## 📋 Prerequisites

1. **PostgreSQL Database**: An existing PostgreSQL database (RDS, Aurora, etc.)
2. **SMTP Server**: For sending authentication emails
3. **Domain Configuration**:
   - `auth.${var.domain.general.name}` for public auth API
   - `supabase.${var.domain.admin.name}` for admin dashboard
4. **Load Balancer**: ALB/NLB configured to route to ECS services
5. **API Gateway** (optional): For additional routing and rate limiting

## 🛠️ Deployment Steps

### 1. Configure Secrets

Create the required secrets in AWS Secrets Manager with the structure above.

### 2. Generate JWT Keys

You'll need to generate JWT keys for anon and service_role:

```bash
# Generate JWT secret (save this)
openssl rand -base64 32

# Use the JWT secret to generate keys at https://supabase.com/docs/guides/hosting/overview#api-keys
```

### 3. Deploy Services

```bash
terraform plan
terraform apply
```

### 4. Configure Database Schema

You'll need to set up the auth schema in your PostgreSQL database:

```sql
-- Run the Supabase auth schema migration
-- This creates the auth.users table and related functions
-- Get the SQL from: https://github.com/supabase/gotrue/blob/master/migrations/
```

## 🔧 Service Discovery

Services communicate using AWS Cloud Map (namespace_id):

- `${var.name}` (GoTrue) - Port 9999
- `${var.name}-rest` (PostgREST) - Port 3000
- `${var.name}-meta` (Postgres Meta) - Port 8080
- `${var.name}-studio` (Studio) - Port 3000

## 📊 Monitoring

All services include:

- **Health Checks**: Proper health check endpoints
- **CloudWatch Logs**: Centralized logging to `/ecs/${service-name}`
- **AWS X-Ray**: Distributed tracing support
- **Sentry Integration**: Error tracking and monitoring

## 🔒 Security

- All services run with least privilege IAM roles
- Database credentials managed via AWS Secrets Manager
- JWT tokens for API authentication
- Rate limiting configured on GoTrue
- HTTPS enforcement for all public endpoints

## 🚀 Next Steps

1. **Frontend Integration**: Configure your frontend to use:

   - Auth URL: `https://auth.${var.domain.general.name}`
   - Use the `anon_key` for client-side requests

2. **Database Setup**: Run Supabase migrations on your PostgreSQL database

3. **DNS Configuration**: Point your domains to the load balancer

4. **SSL Certificates**: Ensure HTTPS is configured for both domains

## 📚 Additional Resources

- [Supabase Self-Hosting Guide](https://supabase.com/docs/guides/hosting/overview)
- [GoTrue Documentation](https://github.com/supabase/gotrue)
- [PostgREST Documentation](https://postgrest.org/en/stable/)
- [Supabase Studio](https://github.com/supabase/supabase/tree/master/studio)
