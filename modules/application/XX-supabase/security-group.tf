# Security Group for GoTrue (Authentication Service)
resource "aws_security_group" "gotrue_sg" {
  depends_on = [var.network]
  name       = "supabase-gotrue-sg"
  vpc_id     = var.network.vpc_id

  tags = {
    Name        = "supabase-gotrue-sg"
    Environment = var.runtime_environment
  }
}

# Security Group for PostgREST (REST API Service)
resource "aws_security_group" "postgrest_sg" {
  depends_on = [var.network]
  name       = "supabase-postgrest-sg"
  vpc_id     = var.network.vpc_id

  tags = {
    Name        = "supabase-postgrest-sg"
    Environment = var.runtime_environment
  }
}

# Security Group for Postgres Meta (Database Management Service)
resource "aws_security_group" "postgres_meta_sg" {
  depends_on = [var.network]
  name       = "supabase-postgres-meta-sg"
  vpc_id     = var.network.vpc_id

  tags = {
    Name        = "supabase-postgres-meta-sg"
    Environment = var.runtime_environment
  }
}

# Security Group for App Runner Studio
resource "aws_security_group" "studio_sg" {
  depends_on = [var.network]
  name       = "supabase-studio-sg"
  vpc_id     = var.network.vpc_id

  tags = {
    Name        = "supabase-studio-sg"
    Environment = var.runtime_environment
  }
}

# Security Group for Kong API Gateway
resource "aws_security_group" "kong_sg" {
  depends_on = [var.network]
  name       = "supabase-kong-sg"
  vpc_id     = var.network.vpc_id

  tags = {
    Name        = "supabase-kong-sg"
    Environment = var.runtime_environment
  }
}

# Realtime Security Group
resource "aws_security_group" "realtime_sg" {
  name_prefix = "supabase-realtime-"
  vpc_id      = var.network.vpc_id

  tags = {
    Name        = "supabase-realtime-sg"
    Environment = var.runtime_environment
  }
}

# Storage API Security Group
resource "aws_security_group" "storage_sg" {
  name_prefix = "supabase-storage-"
  vpc_id      = var.network.vpc_id

  tags = {
    Name        = "supabase-storage-sg"
    Environment = var.runtime_environment
  }
}

# Supavisor Security Group
resource "aws_security_group" "supavisor_sg" {
  name_prefix = "supabase-supavisor-"
  vpc_id      = var.network.vpc_id

  tags = {
    Name        = "supabase-supavisor-sg"
    Environment = var.runtime_environment
  }
}

# ===== EGRESS RULES =====

# GoTrue Egress Rules
resource "aws_vpc_security_group_egress_rule" "gotrue_egress_all" {
  security_group_id = aws_security_group.gotrue_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic for GoTrue"
}

# PostgREST Egress Rules
resource "aws_vpc_security_group_egress_rule" "postgrest_egress_all" {
  security_group_id = aws_security_group.postgrest_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic for PostgREST"
}

# Postgres Meta Egress Rules
resource "aws_vpc_security_group_egress_rule" "postgres_meta_egress_all" {
  security_group_id = aws_security_group.postgres_meta_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic for Postgres Meta"
}

# Studio Egress Rules
resource "aws_vpc_security_group_egress_rule" "studio_egress_all" {
  security_group_id = aws_security_group.studio_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic for Studio"
}

# Kong Egress Rules
resource "aws_vpc_security_group_egress_rule" "kong_egress_all" {
  security_group_id = aws_security_group.kong_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic for Kong"
}

# ===== INGRESS RULES =====

resource "aws_vpc_security_group_ingress_rule" "gotrue_from_studio" {
  security_group_id            = aws_security_group.gotrue_sg.id
  referenced_security_group_id = aws_security_group.studio_sg.id
  from_port                    = 9999
  to_port                      = 9999
  ip_protocol                  = "tcp"
  description                  = "Allow Studio to access GoTrue"
}

resource "aws_vpc_security_group_ingress_rule" "postgrest_from_studio" {
  security_group_id            = aws_security_group.postgrest_sg.id
  referenced_security_group_id = aws_security_group.studio_sg.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
  description                  = "Allow Studio to access PostgREST"
}

# Postgres Meta Ingress Rules (Port 8080)
resource "aws_vpc_security_group_ingress_rule" "postgres_meta_from_studio" {
  security_group_id            = aws_security_group.postgres_meta_sg.id
  referenced_security_group_id = aws_security_group.studio_sg.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  description                  = "Allow Studio to access Postgres Meta"
}

# Kong Ingress Rules (Port 8000 for proxy, 8001 for admin)
resource "aws_vpc_security_group_ingress_rule" "kong_proxy_from_alb" {
  security_group_id            = aws_security_group.kong_sg.id
  referenced_security_group_id = var.external_security_group_ids.alb
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  description                  = "Allow ALB to access Kong proxy"
}

resource "aws_vpc_security_group_ingress_rule" "kong_proxy_from_alb_for_status" {
  security_group_id            = aws_security_group.kong_sg.id
  referenced_security_group_id = var.external_security_group_ids.alb
  from_port                    = 8100
  to_port                      = 8100
  ip_protocol                  = "tcp"
  description                  = "Allow ALB to access Kong proxy for status"
}

# Allow Kong to access Supabase services
resource "aws_vpc_security_group_ingress_rule" "gotrue_from_kong" {
  security_group_id            = aws_security_group.gotrue_sg.id
  referenced_security_group_id = aws_security_group.kong_sg.id
  from_port                    = 9999
  to_port                      = 9999
  ip_protocol                  = "tcp"
  description                  = "Allow Kong to access GoTrue"
}

resource "aws_vpc_security_group_ingress_rule" "postgrest_from_kong" {
  security_group_id            = aws_security_group.postgrest_sg.id
  referenced_security_group_id = aws_security_group.kong_sg.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
  description                  = "Allow Kong to access PostgREST"
}

resource "aws_vpc_security_group_ingress_rule" "postgres_meta_from_kong" {
  security_group_id            = aws_security_group.postgres_meta_sg.id
  referenced_security_group_id = aws_security_group.kong_sg.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  description                  = "Allow Kong to access Postgres Meta"
}

# Allow services to communicate with each other if needed
resource "aws_vpc_security_group_ingress_rule" "gotrue_from_postgrest" {
  security_group_id            = aws_security_group.gotrue_sg.id
  referenced_security_group_id = aws_security_group.postgrest_sg.id
  from_port                    = 9999
  to_port                      = 9999
  ip_protocol                  = "tcp"
  description                  = "Allow PostgREST to access GoTrue for auth validation"
}