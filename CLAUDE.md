# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AWS 基礎建設 Terraform 專案（us-east-1），管理 MLChen 帳號的雙 VPC 網路架構和相關資源。此專案從 2016 年的 HCL 1 語法現代化而來，使用 Terraform 1.5+ import blocks 匯入現有 AWS 資源。

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
```

**注意**：此專案使用 AWS CLI 的 credential chain（~/.aws/config + credentials），無需手動指定 AWS_PROFILE。

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

### Internet Gateway
- `aws_internet_gateway.main` - Main VPC 對外
- `aws_internet_gateway.utility` - Utility VPC 對外

### NAT Instance（目前已註解）
`gateway.tf` 和 `routes.tf` 中的 NAT 資源已註解保留。需要時取消註解並執行 `terraform apply` 即可建立 Ubuntu t3.micro NAT Instance。

## File Organization

| 檔案 | 內容 |
|------|------|
| `vpc.tf` | VPC 定義 |
| `subnets.tf` | 子網路（每 VPC 各 9 個：3 Public + 3 Private + 3 RDS） |
| `gateway.tf` | Internet Gateway + NAT Instance（已註解） |
| `routes.tf` | Route Tables + Routes |
| `peering.tf` | VPC Peering Connection |
| `security_groups.tf` | Security Groups |
| `iam.tf` | IAM Users、Groups、Roles、Policies |
| `rds.tf` | RDS Subnet Group |
| `route53.tf` | Hosted Zones |
| `s3.tf` | S3 Buckets |
| `ec2.tf` | Key Pairs |
| `sns.tf` | SNS Topics |
| `imports.tf` | 現有資源 Import 宣告 |

## Naming Convention

資源命名格式：`${var.proj_name.main}-${var.env_name.main}-<Resource>`

範例：
- VPC: `MLChen-Production`
- Subnet: `MLChen-Production-Public-1`
- Security Group: `MLChen-Production-NAT`

## Import Existing Resources

使用 Terraform 1.5+ import block：

```hcl
# imports.tf
import {
  to = aws_vpc.main
  id = "vpc-xxxxxxxx"
}
```

執行 `terraform plan` 確認無差異後 `terraform apply`。
