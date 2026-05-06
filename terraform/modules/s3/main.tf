# ---------------------------------------------------------------------------
# S3 module — frontend static files bucket with CloudFront OAC
# ---------------------------------------------------------------------------

locals {
  bucket_name = "${var.project_name}-${var.environment}-frontend"
}

# ── S3 Bucket ────────────────────────────────────────────────────────────────
resource "aws_s3_bucket" "frontend" {
  bucket        = local.bucket_name
  force_destroy = false

  tags = {
    Name = local.bucket_name
  }
}

# ── Block all public access ──────────────────────────────────────────────────
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── Server-side encryption ───────────────────────────────────────────────────
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ── Bucket versioning ────────────────────────────────────────────────────────
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ── Origin Access Control ─────────────────────────────────────────────────────
# OAC is defined here so the cloudfront module can reference its ID.
# The S3 bucket policy that allows CloudFront to read objects is defined in the
# root module (main.tf) to avoid a circular dependency between this module and
# the cloudfront module.
resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for ${local.bucket_name} — CloudFront only"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

