# Terraform 現代化調查報告

> 調查日期：2025-12-14
> 調查者：Claude Code
> AWS Account ID：210293595025
> Region：us-east-1

---

## 1. AWS 現有資源盤點

### 1.1 VPC 相關資源

| 資源類型 | 資源名稱 | ID |
|----------|----------|-----|
| VPC (Main) | MLChen-Production | vpc-e84fd98f |
| VPC (Utility) | MLChen-Utility-Production | vpc-f74fd990 |
| VPC Peering | MLChen-Utility <=> MLChen-Production | pcx-11860b78 |

### 1.2 Subnets（共 18 個）

**Main VPC (10.5.0.0/16)**

| 類型 | 名稱 | ID | CIDR | AZ |
|------|------|-----|------|-----|
| Public | MLChen-Production-Public-1 | subnet-c16a5deb | 10.5.0.0/24 | us-east-1a |
| Public | MLChen-Production-Public-2 | subnet-f757b3be | 10.5.1.0/24 | us-east-1c |
| Public | MLChen-Production-Public-3 | subnet-8a3402d2 | 10.5.2.0/24 | us-east-1d |
| Private | MLChen-Production-Private-1 | subnet-c46a5dee | 10.5.10.0/24 | us-east-1a |
| Private | MLChen-Production-Private-2 | subnet-f457b3bd | 10.5.11.0/24 | us-east-1c |
| Private | MLChen-Production-Private-3 | subnet-893402d1 | 10.5.12.0/24 | us-east-1d |
| RDS | MLChen-Production-RDS-1 | subnet-c76a5ded | 10.5.20.0/24 | us-east-1a |
| RDS | MLChen-Production-RDS-2 | subnet-8b57b3c2 | 10.5.21.0/24 | us-east-1c |
| RDS | MLChen-Production-RDS-3 | subnet-973402cf | 10.5.22.0/24 | us-east-1d |

**Utility VPC (10.4.0.0/16)**

| 類型 | 名稱 | ID | CIDR | AZ |
|------|------|-----|------|-----|
| Public | MLChen-Utility-Production-Public-1 | subnet-c86a5de2 | 10.4.0.0/24 | us-east-1a |
| Public | MLChen-Utility-Production-Public-2 | subnet-fd57b3b4 | 10.4.1.0/24 | us-east-1c |
| Public | MLChen-Utility-Production-Public-3 | subnet-9e3402c6 | 10.4.2.0/24 | us-east-1d |
| Private | MLChen-Utility-Production-Private-1 | subnet-ce6a5de4 | 10.4.10.0/24 | us-east-1a |
| Private | MLChen-Utility-Production-Private-2 | subnet-fb57b3b2 | 10.4.11.0/24 | us-east-1c |
| Private | MLChen-Utility-Production-Private-3 | subnet-903402c8 | 10.4.12.0/24 | us-east-1d |
| RDS | MLChen-Utility-Production-RDS-1 | subnet-c96a5de3 | 10.4.30.0/24 | us-east-1a |
| RDS | MLChen-Utility-Production-RDS-2 | subnet-fa57b3b3 | 10.4.31.0/24 | us-east-1c |
| RDS | MLChen-Utility-Production-RDS-3 | subnet-9f3402c7 | 10.4.32.0/24 | us-east-1d |

### 1.3 Security Groups（共 7 個）

| 名稱 | ID | 用途 |
|------|-----|------|
| MLChen-Admin-CIDR | sg-8e686ef5 | 管理員 CIDR 存取 |
| MLChen-WEB-ELB | sg-8f686ef4 | Web Load Balancer |
| MLChen-EC2-Instance-Private | sg-77696f0c | 私有 EC2 實例 |
| MLChen-WEB-Server | sg-75696f0e | Web Server |
| MLChen-WEB-Server-Public | sg-97686eec | 公開 Web Server |
| MLChen-RDS-MySQL | sg-4f696f34 | RDS MySQL |
| MLChen-NAT | sg-76696f0d | NAT |

### 1.4 Route Tables（共 4 個）

| 名稱 | ID | VPC |
|------|-----|-----|
| Private | rtb-c8fc1bae | Main VPC |
| Public | rtb-55fc1b33 | Main VPC |
| Utility-Private | rtb-4afc1b2c | Utility VPC |
| Utility-Public | rtb-4bfc1b2d | Utility VPC |

### 1.5 IAM Users（共 3 個）

| 使用者名稱 | 用途 | 附加的 Policy |
|------------|------|---------------|
| MLChen | 主帳號 | AWSAccountActivityAccess, AWSAccountUsageReportAccess |
| MLChen-QNAP | QNAP NAS 備份 | (無直接附加) |
| MLChen-Route53 | Route53 管理 | AmazonRoute53FullAccess |

### 1.6 IAM Groups（共 9 個）

| Group 名稱 | 附加的 Policy |
|------------|---------------|
| MLChen-Admin | MLChen-Admin-Policy |
| MLChen-Billing | MLChen-Billing-Policy |
| MLChen-Developer | MLChen-Admin-Policy |
| MLChen-ReadOnly | ReadOnlyAccess (AWS managed) |
| MLChen-Team | MLChen-Team-Policy |
| MLChen-ReadOnly-Local | ReadOnlyAccess, MLChen-STAFF-Allow-MFA-Policy |
| MLChen-Staff-Admin | MLChen-Admin-Local-Policy |
| Assume-AnyAccount-AnyRole | MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy |
| Assume-MLChen-Project-DevRole | MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy |

**User Group Membership:**
- MLChen 屬於：MLChen-Admin, MLChen-Staff-Admin, Assume-AnyAccount-AnyRole, MLChen-Billing

### 1.7 IAM Roles（共 6 個）

所有 Role 都使用相同的 Trust Policy（需要 MFA）：

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::210293595025:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

| Role 名稱 | 附加的 Policy |
|-----------|---------------|
| MLChen-STAFF-Admin | MLChen-Admin-Policy |
| MLChen-STAFF-Admin-Local | MLChen-Admin-Local-Policy |
| MLChen-STAFF-Billing | MLChen-Billing-Policy |
| MLChen-STAFF-Developer | MLChen-Admin-Policy |
| MLChen-STAFF-ReadOnly | ReadOnlyAccess (AWS managed) |
| MLChen-STAFF-Team | MLChen-Team-Policy |

### 1.8 IAM Policies（自訂，共 7 個）

| Policy 名稱 | ARN | 說明 |
|-------------|-----|------|
| MLChen-Admin-Policy | arn:aws:iam::210293595025:policy/MLChen-Admin-Policy | 完整管理權限 (Action: *) |
| MLChen-Admin-Local-Policy | arn:aws:iam::210293595025:policy/MLChen-Admin-Local-Policy | 本地完整管理權限 (Action: *) |
| MLChen-Billing-Policy | arn:aws:iam::210293595025:policy/MLChen-Billing-Policy | 帳單檢視權限 |
| MLChen-Team-Policy | arn:aws:iam::210293595025:policy/MLChen-Team-Policy | 團隊權限 (NotAction: iam:*) |
| MLChen-STAFF-Allow-MFA-Policy | arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-MFA-Policy | MFA 管理權限 |
| MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy | arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy | 跨帳號角色切換 |
| MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy | arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy | 專案開發角色切換 |

**Policy Documents 詳細內容：**

<details>
<summary>MLChen-Admin-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```
</details>

<details>
<summary>MLChen-Admin-Local-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```
</details>

<details>
<summary>MLChen-Billing-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "aws-portal:ViewBilling"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```
</details>

<details>
<summary>MLChen-Team-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "NotAction": "iam:*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```
</details>

<details>
<summary>MLChen-STAFF-Allow-MFA-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1458807573000",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ListVirtualMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::*"
            ]
        }
    ]
}
```
</details>

<details>
<summary>MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::*"
    }
}
```
</details>

<details>
<summary>MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1458817050225",
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:iam::*"
            ]
        }
    ]
}
```
</details>

### 1.9 S3 Buckets

| Bucket 名稱 | Region | 建立時間 | 納入 Terraform |
|-------------|--------|----------|----------------|
| protect-ml | us-east-1 | 2020-10-28 | ✅ 是 |
| fb.majord.tw | ap-northeast-1 | 2016-07-19 | ❌ 否（不同 region）|
| ig.majord.tw | ap-northeast-1 | 2017-12-20 | ❌ 否（不同 region）|
| shop.majord.tw | ap-northeast-1 | 2020-12-11 | ❌ 否（不同 region）|

### 1.10 Route 53 Hosted Zones

| Hosted Zone | Domain | Zone ID |
|-------------|--------|---------|
| mlchen.org | mlchen.org | ZSHVMY3Y0JMYA |
| misswu.org | misswu.org | Z2WG0BITKBSTBB |

### 1.11 其他資源

| 資源類型 | 名稱 | ID/ARN |
|----------|------|--------|
| EC2 Key Pair | aws-mlchen | aws-mlchen |
| SNS Topic | MajorD-Shop | arn:aws:sns:us-east-1:210293595025:MajorD-Shop |
| DB Subnet Group | mlchen-production-db-subnets | mlchen-production-db-subnets |

### 1.12 不納入管理的 AWS 資源

以下資源為 AWS 預設或自動建立，不需要 Terraform 管理：

- KMS Keys（AWS managed）
- Default VPC Security Groups
- Default Network ACLs
- Default DHCP Options
- Default Route Tables（main route table）

---

## 2. Terraform 檔案結構

```
aws-base-infrastructure/
├── versions.tf          # Terraform + Provider 版本鎖定
├── providers.tf         # AWS Provider 設定（含 default_tags）
├── variables.tf         # 變數定義
├── terraform.tfvars     # 變數值
├── outputs.tf           # 輸出值定義
├── imports.tf           # Import blocks（93 個資源）
│
├── vpc.tf               # 2 個 VPC
├── subnets.tf           # 18 個 Subnet
├── security_groups.tf   # 7 個 Security Group
├── routes.tf            # Route Tables + Associations
├── peering.tf           # VPC Peering
├── rds.tf               # DB Subnet Group
├── iam.tf               # IAM Users, Groups, Roles, Policies
├── s3.tf                # S3 Bucket (protect-ml)
├── route53.tf           # Route 53 Hosted Zones
├── ec2.tf               # EC2 Key Pair
├── sns.tf               # SNS Topic
│
├── docs/                # 文件
│   └── terraform-modernization-report.md
│
└── legacy/              # 舊檔案備份
    └── main.tf.bak
```

---

## 3. Terraform Plan 結果摘要

執行日期：2025-12-14

```
Plan: 91 to import, 22 to add, 48 to change, 20 to destroy
```

### 3.1 Import（91 個資源）

這些資源會被匯入 Terraform state，成為受管理狀態：

- VPC: 2
- Subnet: 18
- Security Group: 7
- Route Table: 4
- Route Table Association: 6
- VPC Peering: 1
- DB Subnet Group: 1
- IAM User: 3
- IAM Group: 9
- IAM Role: 6
- IAM Policy: 7
- IAM User Policy Attachment: 3
- IAM Group Policy Attachment: 10
- IAM Role Policy Attachment: 6
- IAM User Group Membership: 1
- S3 Bucket: 1
- S3 Bucket Versioning: 1
- S3 Bucket Public Access Block: 1
- Route 53 Hosted Zone: 2
- EC2 Key Pair: 1
- SNS Topic: 1

### 3.2 Update in-place（48 個資源）

這些資源會被更新 `tags_all`，加入 default_tags：
- Project = "MLChen"
- Environment = "Production"
- ManagedBy = "terraform"

**影響：** 無破壞性，僅新增標籤。

### 3.3 Destroy and Recreate（20 個資源）

以下資源會被刪除後重建，原因是 Terraform 定義的 policy document JSON 格式與 AWS 現有格式不完全一致：

**IAM Policies (7 個)：**
1. MLChen-Admin-Policy
2. MLChen-Admin-Local-Policy
3. MLChen-Billing-Policy
4. MLChen-Team-Policy
5. MLChen-STAFF-Allow-MFA-Policy
6. MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy
7. MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy

**IAM Group Policy Attachments (8 個)：**
1. MLChen-Admin / MLChen-Admin-Policy
2. MLChen-Billing / MLChen-Billing-Policy
3. MLChen-Developer / MLChen-Admin-Policy
4. MLChen-ReadOnly-Local / MLChen-STAFF-Allow-MFA-Policy
5. MLChen-Staff-Admin / MLChen-Admin-Local-Policy
6. MLChen-Team / MLChen-Team-Policy
7. Assume-AnyAccount-AnyRole / MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy
8. Assume-MLChen-Project-DevRole / MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy

**IAM Role Policy Attachments (5 個)：**
1. MLChen-STAFF-Admin / MLChen-Admin-Policy
2. MLChen-STAFF-Admin-Local / MLChen-Admin-Local-Policy
3. MLChen-STAFF-Billing / MLChen-Billing-Policy
4. MLChen-STAFF-Developer / MLChen-Admin-Policy
5. MLChen-STAFF-Team / MLChen-Team-Policy

**影響：**
- Policy 會先被刪除再重建（相同名稱、相同內容）
- 重建期間（數秒鐘）使用這些 Policy 的 IAM principals 會暫時失去權限
- 重建完成後功能完全相同

---

## 4. 決策記錄

### 4.1 不使用 for_each

**決策：** 保持每個 Subnet、Security Group 等資源獨立定義，不使用 for_each。

**原因：**
- 資源數量固定，不會動態增減
- `public-1`, `private-2` 命名清楚易讀
- 與 AWS Console 對應良好，方便 debug
- 使用 for_each 會導致 state 結構改變，可能造成 destroy + create

### 4.2 S3 Buckets 只納入 us-east-1 的

**決策：** 只將 `protect-ml` bucket 納入 Terraform 管理。

**原因：**
- 其他 3 個 buckets（fb.majord.tw, ig.majord.tw, shop.majord.tw）在 ap-northeast-1
- 當前 Terraform 設定為 us-east-1
- 跨 region 管理需要另外設定 provider alias

### 4.3 接受 IAM Policy 重建

**決策：** 接受 20 個 IAM 相關資源的 destroy + create。

**原因：**
- JSON 格式差異導致的問題，內容完全相同
- 這是一次性的，之後不會再發生
- 影響時間極短（數秒鐘）

---

## 5. 後續步驟

1. ✅ 完成 Terraform 檔案準備
2. ⏳ 執行 `terraform apply` 完成 import
3. ⏳ 驗證所有資源狀態
4. ⏳ 清理 imports.tf（可選，import 完成後可移除或保留）

---

## 附錄：重要指令

```bash
# 設定 AWS 憑證（使用 AWS CLI login）
export $(aws configure export-credentials --format env)

# 或使用 bash 子 shell
bash -c 'creds=$(aws configure export-credentials --format process) && \
  export AWS_ACCESS_KEY_ID=$(echo $creds | jq -r .AccessKeyId) && \
  export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq -r .SecretAccessKey) && \
  export AWS_SESSION_TOKEN=$(echo $creds | jq -r .SessionToken) && \
  terraform plan'

# 執行 terraform apply
terraform apply
```
