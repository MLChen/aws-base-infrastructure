provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]

  default_tags {
    tags = {
      Project     = var.proj_name.main
      Environment = var.env_name.main
      ManagedBy   = "terraform"
    }
  }
}

# 用於取得當前 AWS 帳號資訊
data "aws_caller_identity" "current" {}
