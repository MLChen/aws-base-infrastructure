################
# S3 Resources #
################

# 應用程式 S3 Bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.proj_name.lowercase}-${var.env_name.lowercase}-${var.app_name}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Purpose = "Application storage"
  }
}

# 啟用版本控制
resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 啟用伺服器端加密
resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_encryption" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 阻擋公開存取
resource "aws_s3_bucket_public_access_block" "app_bucket_public_access" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 生命週期規則 - 清理舊版本
resource "aws_s3_bucket_lifecycle_configuration" "app_bucket_lifecycle" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  rule {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# CORS 設定（如需從瀏覽器直接上傳）
resource "aws_s3_bucket_cors_configuration" "app_bucket_cors" {
  bucket = aws_s3_bucket.app_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]  # 生產環境請限制為特定網域
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
