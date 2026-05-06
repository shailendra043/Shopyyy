# ---------------------------------------------------------------------------
# Kafka module — Amazon MSK cluster (2 brokers across 2 AZs)
# ---------------------------------------------------------------------------

# ── MSK configuration ────────────────────────────────────────────────────────
resource "aws_msk_configuration" "main" {
  name           = "${var.project_name}-${var.environment}-msk-config"
  kafka_versions = [var.msk_kafka_version]
  description    = "MSK configuration for ${var.project_name} ${var.environment}"

  server_properties = <<-EOT
    auto.create.topics.enable=false
    default.replication.factor=2
    min.insync.replicas=1
    num.io.threads=8
    num.network.threads=5
    num.partitions=3
    num.replica.fetchers=2
    replica.lag.time.max.ms=30000
    socket.receive.buffer.bytes=102400
    socket.request.max.bytes=104857600
    socket.send.buffer.bytes=102400
    unclean.leader.election.enable=false
    zookeeper.session.timeout.ms=18000
    log.retention.hours=168
    log.segment.bytes=1073741824
  EOT
}

# ── MSK cluster ───────────────────────────────────────────────────────────────
resource "aws_msk_cluster" "main" {
  cluster_name           = "${var.project_name}-${var.environment}-msk"
  kafka_version          = var.msk_kafka_version
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type  = var.msk_instance_type
    client_subnets = var.private_subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }
    security_groups = [var.msk_security_group_id]
  }

  configuration_info {
    arn      = aws_msk_configuration.main.arn
    revision = aws_msk_configuration.main.latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }

  client_authentication {
    unauthenticated = true
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-msk"
  }
}

# ── CloudWatch log group for MSK broker logs ──────────────────────────────────
resource "aws_cloudwatch_log_group" "msk" {
  name              = "/aws/msk/${var.project_name}-${var.environment}"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-msk-logs"
  }
}
