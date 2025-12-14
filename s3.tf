##############
# S3 Buckets #
##############

# protect-ml (us-east-1)
resource "aws_s3_bucket" "protect-ml" {
  bucket = "protect-ml"

  tags = {
    Name = "protect-ml"
  }
}

resource "aws_s3_bucket_versioning" "protect-ml" {
  bucket = aws_s3_bucket.protect-ml.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "protect-ml" {
  bucket = aws_s3_bucket.protect-ml.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 注意：以下 buckets 在 ap-northeast-1，不在此專案管理範圍
# - fb.majord.tw
# - ig.majord.tw
# - shop.majord.tw
