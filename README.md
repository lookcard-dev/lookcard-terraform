# LookCard Terraform Infrastructure

## Purpose

The LookCard Terraform Infrastructure project provides **comprehensive Infrastructure as Code (IaC)** for the LookCard fintech platform on AWS. It orchestrates a sophisticated microservices architecture supporting crypto-backed credit/debit card services, managing over 20 microservices, databases, networking, security, and monitoring components across multiple environments.

This infrastructure enables LookCard to operate as a compliant fintech platform with enterprise-grade security, scalability, and reliability for financial services, cryptocurrency operations, and regulatory compliance.

## Domain Role

**Infrastructure & DevOps Domain**

The Terraform Infrastructure is responsible for:
- Complete AWS infrastructure provisioning and management
- Multi-environment deployment (develop, staging, production, sandbox)
- Microservices container orchestration via Amazon ECS
- Database infrastructure (Aurora PostgreSQL, ElastiCache Redis, DynamoDB)
- Networking, security, and compliance infrastructure
- CI/CD and deployment automation support

## Key Features & Infrastructure Components

### Multi-Environment Architecture
- **Region**: Primary deployment in `ap-southeast-1` (Singapore)
- **Environments**: develop, testing, staging, production, sandbox
- **Branch-based Deployment**: Git branch names determine environment configurations
- **State Management**: S3 backend with branch-specific state isolation

### Compute Infrastructure
- **6 ECS Clusters**: Specialized clusters for different service types
  - `core-application`: Core financial services (account, card, user APIs)
  - `composite-application`: Composite services (reseller, webhook APIs)
  - `listener`: Event-driven services (crypto transaction monitoring)
  - `administrative`: Administrative and management services
  - `cronjob`: Scheduled tasks and batch processing
  - `supabase`: Database and authentication services

### Microservices Architecture (22+ Services)
- **Core Financial**: account-api, card-api, user-api, verification-api
- **Cryptocurrency**: crypto-api, crypto-listener, crypto-processor
- **Supporting Services**: profile-api, data-api, config-api, notification-api
- **Integration**: webhook-api, reap-proxy, authentication-api
- **Frontend**: web-app (Next.js via AWS App Runner)

### Database Infrastructure
- **Aurora PostgreSQL Serverless v2**: Primary relational database
  - Engine version 16.6 with multi-AZ deployment
  - Serverless scaling (0.5-8.0 capacity units)
  - RDS Proxy for connection pooling
  - IAM authentication and Performance Insights
- **ElastiCache Redis**: Multi-AZ caching layer
- **DynamoDB**: NoSQL storage for specific microservices

## Infrastructure Overview

### Networking Architecture
```
VPC (10.0.0.0/16)
├── Public Subnets (10.0.24.0/23, 10.0.26.0/23, 10.0.28.0/23)
├── Private Subnets (10.0.0.0/21, 10.0.8.0/21, 10.0.16.0/21)
├── Database Subnets (10.0.36.0/24, 10.0.37.0/24, 10.0.38.0/24)
└── Isolated Subnets (10.0.30.0/23, 10.0.32.0/23, 10.0.34.0/23)
```

### Load Balancing & API Gateway
- **Application Load Balancer (ALB)**: HTTP/HTTPS traffic distribution
- **Network Load Balancer (NLB)**: High-performance TCP traffic
- **API Gateway**: External API exposure with VPC Link integration
- **Service Discovery**: AWS Cloud Map for internal communication

### Security Infrastructure
- **AWS Secrets Manager**: Encrypted credential management with KMS
- **KMS Key Management**: Multiple keys for data, crypto operations, liquidity
- **Security Groups**: Least-privilege network access controls
- **VPC Endpoints**: Secure AWS service access
- **Bastion Host**: Secure administrative access

## Service Dependencies

### AWS Services
- **Compute**: ECS, Lambda, App Runner
- **Database**: Aurora PostgreSQL, ElastiCache Redis, DynamoDB
- **Storage**: S3, ECR (container registry)
- **Networking**: VPC, ALB, NLB, API Gateway, Route 53, CloudFront
- **Security**: IAM, KMS, Secrets Manager, Security Groups
- **Monitoring**: CloudWatch, X-Ray, Container Insights

### External Providers
- **Cloudflare**: DNS and CDN services
- **GitHub**: CI/CD integration and source control

### Multi-Account Structure
- **Application Account**: Primary AWS account for infrastructure
- **DNS Account**: Separate account for DNS management
- **Cross-account IAM**: Secure resource access across accounts

## Technologies Used

### Infrastructure as Code
- **Terraform**: Infrastructure provisioning and management
- **HCL**: HashiCorp Configuration Language
- **Terraform Modules**: Reusable infrastructure components
- **Remote State**: S3 backend with DynamoDB locking

### Deployment & Automation
- **Makefile**: Simplified deployment commands
- **Branch-based Environments**: Git integration for environment management
- **Environment Variables**: `.env` files and AWS Secrets Manager
- **Container Orchestration**: Amazon ECS with Fargate

### DevOps Tools
- **Infracost**: Cost analysis and optimization
- **Docker**: Container management and registry (ECR)
- **GitHub Actions**: CI/CD pipeline integration
- **Rover**: Terraform visualization

## Configuration & Environment

### Branch-Based Environment Management
```bash
# Environment mapping based on Git branch
develop → Development environment
staging → Staging environment  
production → Production environment
testing → Testing environment
sandbox → Sandbox environment
```

### Required Tools
```bash
# Core tools
terraform >= 1.0
aws-cli >= 2.0
docker >= 20.0
make

# Optional tools
infracost        # Cost analysis
terraform-docs   # Documentation generation
rover           # Infrastructure visualization
```

### Environment Variables
```bash
# AWS Configuration
AWS_PROFILE=lookcard-terraform
AWS_REGION=ap-southeast-1
AWS_ACCOUNT_ID=your-account-id

# Terraform Configuration
TF_VAR_environment=develop
TF_VAR_git_branch=develop
TF_VAR_git_commit_hash=your-commit-hash

# Domain Configuration
TF_VAR_domain_name=lookcard.com
TF_VAR_dns_account_id=your-dns-account-id
```

## Deployment & Runtime

### Infrastructure Commands
```bash
# Initialize Terraform with environment-specific backend
make init

# Preview infrastructure changes
make plan

# Apply infrastructure changes
make apply

# Format Terraform files
make fmt

# Refresh Terraform state
make refresh

# Cost analysis
make cost
```

### Manual Terraform Commands
```bash
# Initialize with specific branch
terraform init -backend-config="profile=lookcard-terraform" \
               -backend-config="key=develop/terraform.tfstate"

# Plan with environment variables
terraform plan -var-file="terraform.develop.tfvars.json"

# Apply with environment variables
terraform apply -var-file="terraform.develop.tfvars.json"
```

### Environment-Specific Configurations
- **Development**: Single-AZ, reduced monitoring, cost-optimized
- **Staging**: Production-like with reduced capacity
- **Production**: Multi-AZ, full monitoring, auto-scaling, backup enabled
- **Testing**: Lightweight for integration testing
- **Sandbox**: Isolated environment for experimentation

## Security Considerations

### Compliance & Governance
- **SOC 2 Type II**: Infrastructure patterns for compliance
- **PCI DSS**: Payment card industry security standards
- **Data Encryption**: Encryption at rest and in transit
- **Access Control**: IAM roles with least-privilege principles

### Network Security
- **VPC Isolation**: Private subnets for sensitive workloads
- **Security Groups**: Granular network access controls
- **VPC Endpoints**: Secure AWS service communication
- **Network ACLs**: Additional network-layer security

### Data Protection
- **Encryption at Rest**: KMS-encrypted databases and storage
- **Secrets Management**: AWS Secrets Manager with automatic rotation
- **Backup Strategy**: Automated backups with configurable retention
- **Audit Logging**: Comprehensive CloudTrail and CloudWatch logging

### Identity & Access Management
- **Cross-account Roles**: Secure multi-account access
- **Service Roles**: Dedicated IAM roles for each service
- **Temporary Credentials**: STS for time-limited access
- **MFA Requirements**: Multi-factor authentication for admin access

## Monitoring & Observability

### Comprehensive Monitoring Stack
- **AWS X-Ray**: Distributed tracing across all microservices
- **CloudWatch**: Metrics, logs, and alerting
- **Container Insights**: ECS performance monitoring (production)
- **Performance Insights**: Database performance monitoring

### Cost Management
- **Environment-specific Scaling**: Optimized resource allocation
- **Infracost Integration**: Automated cost analysis
- **Resource Tagging**: Comprehensive cost tracking
- **Scheduled Scaling**: Development environment cost optimization

## High Availability & Disaster Recovery

### Multi-AZ Architecture
- **Database Layer**: Aurora with read replicas
- **Cache Layer**: ElastiCache with automatic failover
- **Compute Layer**: ECS across multiple availability zones
- **Load Balancing**: Health checks and automatic failover

### Backup & Recovery
- **Database Backups**: Automated with point-in-time recovery
- **Infrastructure State**: Versioned Terraform state files
- **Container Images**: Immutable images in ECR with lifecycle policies
- **Configuration Management**: Versioned environment configurations

### Scalability Features
- **Auto Scaling**: ECS services with capacity providers
- **Serverless Components**: Aurora Serverless v2, Lambda functions
- **CDN Integration**: CloudFront for global content delivery
- **API Rate Limiting**: Gateway throttling and quota management

---

*This infrastructure serves as the foundation for LookCard's fintech platform, providing enterprise-grade security, compliance, and scalability for cryptocurrency-backed financial services while maintaining operational excellence and cost efficiency.*