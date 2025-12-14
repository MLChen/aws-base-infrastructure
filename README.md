# AWS Base Infrastructure

AWS 基礎建設 Terraform 專案（us-east-1），管理雙 VPC 網路架構和相關 AWS 資源。

## 功能

- 雙 VPC 架構（Main + Utility）with VPC Peering
- 多可用區域子網路（Public / Private / RDS × 3 AZ）
- Internet Gateway（兩個 VPC 各一個）
- NAT Instance（程式碼已備妥，目前註解）
- Security Groups 預設配置
- IAM Users、Groups、Roles、Policies
- Route 53 Hosted Zones
- S3 Buckets

## 前置需求

- [Terraform](https://www.terraform.io/downloads) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured

## 快速開始

```bash
# 複製變數範本
cp variables.tf.sample terraform.tfvars

# 編輯變數
vim terraform.tfvars

# 初始化
terraform init

# 預覽變更
terraform plan

# 套用變更
terraform apply
```

## 查看 Outputs

```bash
# 列出所有輸出
terraform output

# VPC IDs
terraform output main_vpc_id
terraform output utility_vpc_id

# Subnet IDs
terraform output public_subnet_ids
terraform output private_subnet_ids

# Security Group IDs
terraform output web_elb_security_group_id
```

## 啟用 NAT Instance

NAT Instance 程式碼已在 `gateway.tf` 和 `routes.tf` 中註解保留。啟用步驟：

1. 取消 `gateway.tf` 中 NAT 相關資源的註解
2. 取消 `routes.tf` 中 `aws_route.main-private-nat` 的註解
3. 執行 `terraform apply`

## Import 現有資源

使用 Terraform 1.5+ import block：

```hcl
# imports.tf
import {
  to = aws_vpc.main
  id = "vpc-xxxxxxxx"
}
```

執行 `terraform plan` 確認無差異後 `terraform apply`。

## 檔案結構

```
├── vpc.tf              # VPC 定義
├── subnets.tf          # 子網路
├── gateway.tf          # Internet Gateway + NAT Instance
├── routes.tf           # Route Tables
├── peering.tf          # VPC Peering
├── security_groups.tf  # Security Groups
├── iam.tf              # IAM 資源
├── rds.tf              # RDS Subnet Group
├── route53.tf          # Route 53 Hosted Zones
├── s3.tf               # S3 Buckets
├── ec2.tf              # EC2 Key Pairs
├── sns.tf              # SNS Topics
├── imports.tf          # Import 宣告
├── variables.tf        # 變數定義
├── outputs.tf          # 輸出值
├── providers.tf        # Provider 設定
├── versions.tf         # 版本鎖定
└── backend.tf          # Backend 設定
```
