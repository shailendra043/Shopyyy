# ---------------------------------------------------------------------------
# Caching module — ElastiCache Redis replication group (1 node)
# ---------------------------------------------------------------------------

# ── ElastiCache subnet group ──────────────────────────────────────────────────
resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids  = var.private_subnet_ids
  description = "Private subnet group for ElastiCache Redis"

  tags = {
    Name = "${var.project_name}-${var.environment}-redis-subnet-group"
  }
}

# ── ElastiCache parameter group ───────────────────────────────────────────────
resource "aws_elasticache_parameter_group" "main" {
  name        = "${var.project_name}-${var.environment}-redis7"
  family      = "redis7.1"
  description = "Parameter group for Redis 7.1"

  tags = {
    Name = "${var.project_name}-${var.environment}-redis7"
  }
}

# ── Redis replication group (single node) ────────────────────────────────────
resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"
  description          = "Redis cache for ${var.project_name} ${var.environment}"

  node_type            = var.redis_node_type
  num_cache_clusters   = 1
  parameter_group_name = aws_elasticache_parameter_group.main.name
  engine_version       = "7.1"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [var.elasticache_security_group_id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.redis_auth.result

  automatic_failover_enabled = false
  multi_az_enabled           = false

  snapshot_retention_limit = 1
  snapshot_window          = "05:00-06:00"
  maintenance_window       = "sun:06:00-sun:07:00"

  apply_immediately = false

  tags = {
    Name = "${var.project_name}-${var.environment}-redis"
  }
}

# ── Random auth token for Redis ───────────────────────────────────────────────
resource "random_password" "redis_auth" {
  length  = 32
  special = false
}

# ── Store Redis auth token in Secrets Manager ─────────────────────────────────
resource "aws_secretsmanager_secret" "redis_auth" {
  name                    = "${var.project_name}/${var.environment}/redis/auth-token"
  description             = "Redis AUTH token for ${var.project_name} ${var.environment}"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-redis-auth"
  }
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id     = aws_secretsmanager_secret.redis_auth.id
  secret_string = random_password.redis_auth.result
}
