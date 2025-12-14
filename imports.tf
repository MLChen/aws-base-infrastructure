#######################
# Terraform Imports   #
# 現有 AWS 資源匯入宣告 #
#######################

# ========== VPCs ==========
import {
  to = aws_vpc.main
  id = "vpc-e84fd98f"
}

import {
  to = aws_vpc.utility
  id = "vpc-f74fd990"
}

# ========== Main VPC Subnets ==========
# Public Subnets
import {
  to = aws_subnet.public-1
  id = "subnet-c16a5deb"
}

import {
  to = aws_subnet.public-2
  id = "subnet-f757b3be"
}

import {
  to = aws_subnet.public-3
  id = "subnet-8a3402d2"
}

# Private Subnets
import {
  to = aws_subnet.private-1
  id = "subnet-c46a5dee"
}

import {
  to = aws_subnet.private-2
  id = "subnet-f457b3bd"
}

import {
  to = aws_subnet.private-3
  id = "subnet-893402d1"
}

# RDS Subnets
import {
  to = aws_subnet.rds-1
  id = "subnet-c76a5ded"
}

import {
  to = aws_subnet.rds-2
  id = "subnet-8b57b3c2"
}

import {
  to = aws_subnet.rds-3
  id = "subnet-973402cf"
}

# ========== Utility VPC Subnets ==========
# Public Subnets
import {
  to = aws_subnet.utility-public-1
  id = "subnet-c86a5de2"
}

import {
  to = aws_subnet.utility-public-2
  id = "subnet-fd57b3b4"
}

import {
  to = aws_subnet.utility-public-3
  id = "subnet-9e3402c6"
}

# Private Subnets
import {
  to = aws_subnet.utility-private-1
  id = "subnet-ce6a5de4"
}

import {
  to = aws_subnet.utility-private-2
  id = "subnet-fb57b3b2"
}

import {
  to = aws_subnet.utility-private-3
  id = "subnet-903402c8"
}

# RDS Subnets
import {
  to = aws_subnet.utility-rds-1
  id = "subnet-c96a5de3"
}

import {
  to = aws_subnet.utility-rds-2
  id = "subnet-fa57b3b3"
}

import {
  to = aws_subnet.utility-rds-3
  id = "subnet-9f3402c7"
}

# ========== Security Groups ==========
import {
  to = aws_security_group.admin-cidr
  id = "sg-8e686ef5"
}

import {
  to = aws_security_group.web-elb
  id = "sg-8f686ef4"
}

import {
  to = aws_security_group.ec2-instance-private
  id = "sg-77696f0c"
}

import {
  to = aws_security_group.web-server
  id = "sg-75696f0e"
}

import {
  to = aws_security_group.web-server-pubilc
  id = "sg-97686eec"
}

import {
  to = aws_security_group.rds-mysql
  id = "sg-4f696f34"
}

import {
  to = aws_security_group.nat
  id = "sg-76696f0d"
}

# ========== Route Tables ==========
import {
  to = aws_route_table.private
  id = "rtb-c8fc1bae"
}

import {
  to = aws_route_table.public
  id = "rtb-55fc1b33"
}

import {
  to = aws_route_table.utility-private
  id = "rtb-4afc1b2c"
}

import {
  to = aws_route_table.utility-public
  id = "rtb-4bfc1b2d"
}

# ========== VPC Peering ==========
import {
  to = aws_vpc_peering_connection.utility
  id = "pcx-11860b78"
}

# ========== DB Subnet Group ==========
import {
  to = aws_db_subnet_group.db-subnet-group
  id = "mlchen-production-db-subnets"
}

# ========== Route Table Associations ==========
# Main VPC Public Subnets
import {
  to = aws_route_table_association.public-1
  id = "subnet-c16a5deb/rtb-55fc1b33"
}

import {
  to = aws_route_table_association.public-2
  id = "subnet-f757b3be/rtb-55fc1b33"
}

import {
  to = aws_route_table_association.public-3
  id = "subnet-8a3402d2/rtb-55fc1b33"
}

# Utility VPC Public Subnets
import {
  to = aws_route_table_association.utility-public-1
  id = "subnet-c86a5de2/rtb-4bfc1b2d"
}

import {
  to = aws_route_table_association.utility-public-2
  id = "subnet-fd57b3b4/rtb-4bfc1b2d"
}

import {
  to = aws_route_table_association.utility-public-3
  id = "subnet-9e3402c6/rtb-4bfc1b2d"
}

# ========== Main Route Table Associations ==========
# 注意：aws_main_route_table_association 不支援 import
# 這些資源會由 Terraform 重新建立（無破壞性，只是重新指定 main route table）

# ========== S3 Buckets ==========
# 注意：只有 protect-ml 在 us-east-1，其他 buckets 在 ap-northeast-1
import {
  to = aws_s3_bucket.protect-ml
  id = "protect-ml"
}

import {
  to = aws_s3_bucket_versioning.protect-ml
  id = "protect-ml"
}

import {
  to = aws_s3_bucket_public_access_block.protect-ml
  id = "protect-ml"
}

# ========== Route 53 Hosted Zones ==========
import {
  to = aws_route53_zone.mlchen-org
  id = "ZSHVMY3Y0JMYA"
}

import {
  to = aws_route53_zone.misswu-org
  id = "Z2WG0BITKBSTBB"
}

# ========== IAM Users ==========
import {
  to = aws_iam_user.mlchen
  id = "MLChen"
}

import {
  to = aws_iam_user.mlchen-qnap
  id = "MLChen-QNAP"
}

import {
  to = aws_iam_user.mlchen-route53
  id = "MLChen-Route53"
}

# ========== IAM User Policy Attachments ==========
import {
  to = aws_iam_user_policy_attachment.mlchen-account-activity
  id = "MLChen/arn:aws:iam::aws:policy/AWSAccountActivityAccess"
}

import {
  to = aws_iam_user_policy_attachment.mlchen-usage-report
  id = "MLChen/arn:aws:iam::aws:policy/AWSAccountUsageReportAccess"
}

import {
  to = aws_iam_user_policy_attachment.mlchen-route53-full-access
  id = "MLChen-Route53/arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

# ========== IAM Groups ==========
import {
  to = aws_iam_group.mlchen-admin
  id = "MLChen-Admin"
}

import {
  to = aws_iam_group.mlchen-billing
  id = "MLChen-Billing"
}

import {
  to = aws_iam_group.mlchen-developer
  id = "MLChen-Developer"
}

import {
  to = aws_iam_group.mlchen-readonly
  id = "MLChen-ReadOnly"
}

import {
  to = aws_iam_group.mlchen-team
  id = "MLChen-Team"
}

import {
  to = aws_iam_group.mlchen-readonly-local
  id = "MLChen-ReadOnly-Local"
}

import {
  to = aws_iam_group.mlchen-staff-admin
  id = "MLChen-Staff-Admin"
}

import {
  to = aws_iam_group.assume-anyaccount-anyrole
  id = "Assume-AnyAccount-AnyRole"
}

import {
  to = aws_iam_group.assume-mlchen-project-devrole
  id = "Assume-MLChen-Project-DevRole"
}

# ========== IAM User Group Membership ==========
import {
  to = aws_iam_user_group_membership.mlchen-groups
  id = "MLChen/MLChen-Admin,MLChen-Staff-Admin,Assume-AnyAccount-AnyRole,MLChen-Billing"
}

# ========== IAM Policies (Custom) ==========
import {
  to = aws_iam_policy.mlchen-admin-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-Admin-Policy"
}

import {
  to = aws_iam_policy.mlchen-admin-local-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-Admin-Local-Policy"
}

import {
  to = aws_iam_policy.mlchen-billing-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-Billing-Policy"
}

import {
  to = aws_iam_policy.mlchen-team-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-Team-Policy"
}

import {
  to = aws_iam_policy.mlchen-staff-allow-mfa-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-MFA-Policy"
}

# 已被刪除重建，不需要 import
# import {
#   to = aws_iam_policy.mlchen-staff-allow-assume-anyaccount-anyrole-policy
#   id = "arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy"
# }

import {
  to = aws_iam_policy.mlchen-staff-allow-assume-mlchen-project-devrole-policy
  id = "arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy"
}

# ========== IAM Group Policy Attachments ==========
import {
  to = aws_iam_group_policy_attachment.mlchen-admin-policy
  id = "MLChen-Admin/arn:aws:iam::210293595025:policy/MLChen-Admin-Policy"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-billing-policy
  id = "MLChen-Billing/arn:aws:iam::210293595025:policy/MLChen-Billing-Policy"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-developer-policy
  id = "MLChen-Developer/arn:aws:iam::210293595025:policy/MLChen-Admin-Policy"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-readonly-policy
  id = "MLChen-ReadOnly/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-team-policy
  id = "MLChen-Team/arn:aws:iam::210293595025:policy/MLChen-Team-Policy"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-readonly-local-mfa
  id = "MLChen-ReadOnly-Local/arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-MFA-Policy"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-readonly-local-readonly
  id = "MLChen-ReadOnly-Local/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

import {
  to = aws_iam_group_policy_attachment.mlchen-staff-admin-policy
  id = "MLChen-Staff-Admin/arn:aws:iam::210293595025:policy/MLChen-Admin-Local-Policy"
}

# 已被刪除重建，不需要 import
# import {
#   to = aws_iam_group_policy_attachment.assume-anyaccount-anyrole-policy
#   id = "Assume-AnyAccount-AnyRole/arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy"
# }

import {
  to = aws_iam_group_policy_attachment.assume-mlchen-project-devrole-policy
  id = "Assume-MLChen-Project-DevRole/arn:aws:iam::210293595025:policy/MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy"
}

# ========== IAM Roles ==========
import {
  to = aws_iam_role.mlchen-staff-admin
  id = "MLChen-STAFF-Admin"
}

import {
  to = aws_iam_role.mlchen-staff-admin-local
  id = "MLChen-STAFF-Admin-Local"
}

import {
  to = aws_iam_role.mlchen-staff-billing
  id = "MLChen-STAFF-Billing"
}

import {
  to = aws_iam_role.mlchen-staff-developer
  id = "MLChen-STAFF-Developer"
}

import {
  to = aws_iam_role.mlchen-staff-readonly
  id = "MLChen-STAFF-ReadOnly"
}

import {
  to = aws_iam_role.mlchen-staff-team
  id = "MLChen-STAFF-Team"
}

# ========== IAM Role Policy Attachments ==========
import {
  to = aws_iam_role_policy_attachment.mlchen-staff-admin-policy
  id = "MLChen-STAFF-Admin/arn:aws:iam::210293595025:policy/MLChen-Admin-Policy"
}

import {
  to = aws_iam_role_policy_attachment.mlchen-staff-admin-local-policy
  id = "MLChen-STAFF-Admin-Local/arn:aws:iam::210293595025:policy/MLChen-Admin-Local-Policy"
}

import {
  to = aws_iam_role_policy_attachment.mlchen-staff-billing-policy
  id = "MLChen-STAFF-Billing/arn:aws:iam::210293595025:policy/MLChen-Billing-Policy"
}

import {
  to = aws_iam_role_policy_attachment.mlchen-staff-developer-policy
  id = "MLChen-STAFF-Developer/arn:aws:iam::210293595025:policy/MLChen-Admin-Policy"
}

import {
  to = aws_iam_role_policy_attachment.mlchen-staff-readonly-policy
  id = "MLChen-STAFF-ReadOnly/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

import {
  to = aws_iam_role_policy_attachment.mlchen-staff-team-policy
  id = "MLChen-STAFF-Team/arn:aws:iam::210293595025:policy/MLChen-Team-Policy"
}

# ========== EC2 Key Pairs ==========
import {
  to = aws_key_pair.aws-mlchen
  id = "aws-mlchen"
}

# ========== SNS Topics ==========
import {
  to = aws_sns_topic.majord-shop
  id = "arn:aws:sns:us-east-1:210293595025:MajorD-Shop"
}

# ========== VPC Peering Routes ==========
import {
  to = aws_route.main-private-peering
  id = "rtb-c8fc1bae_10.4.0.0/16"
}

import {
  to = aws_route.main-public-peering
  id = "rtb-55fc1b33_10.4.0.0/16"
}

import {
  to = aws_route.utility-private-peering
  id = "rtb-4afc1b2c_10.5.0.0/16"
}

import {
  to = aws_route.utility-public-peering
  id = "rtb-4bfc1b2d_10.5.0.0/16"
}
