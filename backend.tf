# Terraform Backend Configuration
#
# 目前使用 local backend。執行 bootstrap/ 後，請取消下方 S3 backend 的註解。
#
# 切換步驟：
# 1. cd bootstrap/ && terraform init && terraform apply
# 2. 取得 outputs 中的 bucket 名稱和 DynamoDB table 名稱
# 3. 更新下方 S3 backend 設定
# 4. 執行 terraform init -migrate-state

# 暫時使用 local backend
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# 執行 bootstrap 後，請使用以下 S3 backend（取消註解並填入值）
# terraform {
#   backend "s3" {
#     bucket         = "YOUR_STATE_BUCKET_NAME"        # 從 bootstrap outputs 取得
#     key            = "aws-base-infrastructure/terraform.tfstate"
#     region         = "ap-northeast-1"
#     encrypt        = true
#     dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME"      # 從 bootstrap outputs 取得
#   }
# }
