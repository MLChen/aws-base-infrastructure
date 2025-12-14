#################
# IAM Resources #
#################

# 應用程式使用的 IAM User
resource "aws_iam_user" "app_user" {
  name = "${var.proj_name.lowercase}-${var.env_name.lowercase}-${var.app_name}"
  path = "/applications/"

  tags = {
    Purpose = "Application S3 access"
  }
}

# IAM Policy - S3 存取權限（最小權限原則）
resource "aws_iam_policy" "app_s3_policy" {
  name        = "${var.proj_name.lowercase}-${var.env_name.lowercase}-${var.app_name}-s3-access"
  description = "S3 access policy for ${var.app_name} application"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketListAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.app_bucket.arn
        ]
      },
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectAcl",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "${aws_s3_bucket.app_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 將 Policy 附加到 User
resource "aws_iam_user_policy_attachment" "app_s3_attachment" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.app_s3_policy.arn
}

# IAM Access Key（用於外部應用程式）
resource "aws_iam_access_key" "app_user_key" {
  user = aws_iam_user.app_user.name
}
