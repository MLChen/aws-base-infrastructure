# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AWS 基礎建設 Terraform 專案（us-east-1），管理雙 VPC 網路架構和相關資源。使用 Terraform 1.5+ 並採用 `for_each` 動態資源管理模式，所有資源可透過 `terraform.tfvars` 設定。

## Commands

```bash
# 初始化
terraform init

# 預覽變更
terraform plan

# 套用變更
terraform apply

# 查看 state
terraform state list
terraform state show <resource>

# 查看輸出（含 sensitive）
terraform output
terraform output -json s3_app_secret_keys
```

**注意**：此專案使用 AWS CLI 的 credential chain（~/.aws/config + credentials），無需手動指定 AWS_PROFILE。

## Configuration

- `terraform.tfvars` - 實際設定值（gitignored，不提交）
- `terraform.tfvars.sample` - 設定範本（提交至版控）

新環境設定：
```bash
cp terraform.tfvars.sample terraform.tfvars
vim terraform.tfvars
```

## Architecture

### 雙 VPC 架構
```
Main VPC (10.5.0.0/16)              Utility VPC (10.4.0.0/16)
├── Public Subnets (10.5.10-12)    ├── Public Subnets (10.4.10-12)
├── Private Subnets (10.5.20-22)   ├── Private Subnets (10.4.20-22)
└── RDS Subnets (10.5.30-32)       └── RDS Subnets (10.4.30-32)
         │                                    │
         └──────── VPC Peering ───────────────┘
```

### 流量路徑
| 流量 | 路徑 |
|------|------|
| 入站 | Internet → ELB (Utility Public) → VPC Peering → Services (Main Private) |
| 出站 | Services (Main Private) → NAT (Main Public) → IGW → Internet |

### NAT Instance（目前已註解）
`gateway.tf` 和 `routes.tf` 中的 NAT 資源已註解保留。需要時取消註解並執行 `terraform apply`。

## Resource Management Pattern

所有動態資源使用 `for_each` 搭配 map 變數，新增資源只需修改 `terraform.tfvars`：

### 新增 IAM User
```hcl
iam_users = {
  "NewUser" = {
    groups           = ["Admin", "Developer"]  # 群組後綴
    managed_policies = ["arn:aws:iam::aws:policy/..."]
    create_access_key = false
  }
}
```

### 新增 IAM Group
```hcl
iam_groups = {
  "NewGroup" = { policy_type = "developer" }
  # policy_type: admin|billing|developer|readonly|team|readonly-local|staff-admin|assume-any|assume-project
}
```

### 新增 S3 Bucket
```hcl
s3_buckets = {
  "my-bucket" = {
    versioning          = true
    block_public_access = true
    # 可選：cors, public_read_prefix, app_user
  }
}
```

### 新增 Route53 / SNS / EC2 Key Pair
```hcl
route53_zones = { "example-com" = "example.com" }
sns_topics    = { "alerts" = "MyProject-Alerts" }
key_pairs     = { "main" = "my-key-name" }
```

## Naming Convention

資源命名格式：`${var.proj_name.main}-${var.env_name.main}-<Resource>`

- VPC: `MLChen-Production`
- IAM Group: `MLChen-Admin`（proj_name + group key）
- IAM Role: `MLChen-STAFF-Admin`

## File Organization

| 檔案 | 內容 |
|------|------|
| `vpc.tf` | VPC 定義 |
| `subnets.tf` | 子網路（每 VPC 各 9 個） |
| `gateway.tf` | Internet Gateway + NAT Instance（已註解） |
| `routes.tf` | Route Tables + Routes |
| `peering.tf` | VPC Peering Connection |
| `security_groups.tf` | Security Groups |
| `iam.tf` | IAM Users、Groups、Roles、Policies（for_each） |
| `s3.tf` | S3 Buckets（for_each） |
| `route53.tf` | Hosted Zones（for_each） |
| `sns.tf` | SNS Topics（for_each） |
| `ec2.tf` | Key Pairs（for_each） |
| `imports.tf` | 現有資源 Import 宣告 |

## Import Existing Resources

使用 Terraform 1.5+ import block：

```hcl
# imports.tf
import {
  to = aws_s3_bucket.buckets["my-bucket"]
  id = "my-bucket"
}
```

執行 `terraform plan` 確認無差異後 `terraform apply`。
