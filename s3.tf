##############
# S3 Buckets #
##############

resource "aws_s3_bucket" "buckets" {
  for_each = var.s3_buckets

  bucket = each.key

  tags = {
    Name = each.key
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "buckets" {
  for_each = { for k, v in var.s3_buckets : k => v if v.versioning }

  bucket = aws_s3_bucket.buckets[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.buckets[each.key].id

  block_public_acls       = each.value.block_public_access
  block_public_policy     = each.value.block_public_access
  ignore_public_acls      = each.value.block_public_access
  restrict_public_buckets = each.value.block_public_access
}

# Bucket Policy for public read prefixes
resource "aws_s3_bucket_policy" "public_read" {
  for_each = { for k, v in var.s3_buckets : k => v if v.public_read_prefixes != null }

  bucket = aws_s3_bucket.buckets[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = [for prefix in each.value.public_read_prefixes : "${aws_s3_bucket.buckets[each.key].arn}/${prefix}/*"]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.buckets]
}

# CORS Configuration
resource "aws_s3_bucket_cors_configuration" "buckets" {
  for_each = { for k, v in var.s3_buckets : k => v if v.cors != null }

  bucket = aws_s3_bucket.buckets[each.key].id

  cors_rule {
    allowed_headers = each.value.cors.allowed_headers
    allowed_methods = each.value.cors.allowed_methods
    allowed_origins = each.value.cors.allowed_origins
    expose_headers  = each.value.cors.expose_headers
  }
}
