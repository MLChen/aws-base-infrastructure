#############
# IAM Users #
#############

resource "aws_iam_user" "mlchen" {
  name = "MLChen"
  tags = { Name = "MLChen" }
}

resource "aws_iam_user" "mlchen-qnap" {
  name = "MLChen-QNAP"
  tags = { Name = "MLChen-QNAP" }
}

resource "aws_iam_user" "mlchen-route53" {
  name = "MLChen-Route53"
  tags = { Name = "MLChen-Route53" }
}

###########################
# IAM User Policy Attachments #
###########################

resource "aws_iam_user_policy_attachment" "mlchen-account-activity" {
  user       = aws_iam_user.mlchen.name
  policy_arn = "arn:aws:iam::aws:policy/AWSAccountActivityAccess"
}

resource "aws_iam_user_policy_attachment" "mlchen-usage-report" {
  user       = aws_iam_user.mlchen.name
  policy_arn = "arn:aws:iam::aws:policy/AWSAccountUsageReportAccess"
}

resource "aws_iam_user_policy_attachment" "mlchen-route53-full-access" {
  user       = aws_iam_user.mlchen-route53.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

##############
# IAM Groups #
##############

resource "aws_iam_group" "mlchen-admin" {
  name = "MLChen-Admin"
}

resource "aws_iam_group" "mlchen-billing" {
  name = "MLChen-Billing"
}

resource "aws_iam_group" "mlchen-developer" {
  name = "MLChen-Developer"
}

resource "aws_iam_group" "mlchen-readonly" {
  name = "MLChen-ReadOnly"
}

resource "aws_iam_group" "mlchen-team" {
  name = "MLChen-Team"
}

resource "aws_iam_group" "mlchen-readonly-local" {
  name = "MLChen-ReadOnly-Local"
}

resource "aws_iam_group" "mlchen-staff-admin" {
  name = "MLChen-Staff-Admin"
}

resource "aws_iam_group" "assume-anyaccount-anyrole" {
  name = "Assume-AnyAccount-AnyRole"
}

resource "aws_iam_group" "assume-mlchen-project-devrole" {
  name = "Assume-MLChen-Project-DevRole"
}

############################
# IAM User Group Memberships #
############################

resource "aws_iam_user_group_membership" "mlchen-groups" {
  user = aws_iam_user.mlchen.name
  groups = [
    aws_iam_group.mlchen-admin.name,
    aws_iam_group.mlchen-staff-admin.name,
    aws_iam_group.assume-anyaccount-anyrole.name,
    aws_iam_group.mlchen-billing.name,
  ]
}

##########################
# IAM Policies (Custom)  #
##########################

resource "aws_iam_policy" "mlchen-admin-policy" {
  name        = "MLChen-Admin-Policy"
  description = "MLChen Admin Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-admin-local-policy" {
  name        = "MLChen-Admin-Local-Policy"
  description = "MLChen Admin Local Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-billing-policy" {
  name        = "MLChen-Billing-Policy"
  description = "MLChen Billing Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["aws-portal:ViewBilling"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-team-policy" {
  name        = "MLChen-Team-Policy"
  description = "MLChen Team Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        NotAction = "iam:*"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-staff-allow-mfa-policy" {
  name        = "MLChen-STAFF-Allow-MFA-Policy"
  description = "MLChen STAFF Allow MFA Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Stmt1458807573000"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:DeactivateMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = ["arn:aws:iam::*"]
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-staff-allow-assume-anyaccount-anyrole-policy" {
  name        = "MLChen-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy"
  description = "MLChen STAFF Allow Assume AnyAccount AnyRole Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::*"
      }
    ]
  })
}

resource "aws_iam_policy" "mlchen-staff-allow-assume-mlchen-project-devrole-policy" {
  name        = "MLChen-STAFF-Allow-Assume-MLChen-Project-DevRole-Policy"
  description = "MLChen STAFF Allow Assume MLChen Project DevRole Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Stmt1458817050225"
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = ["arn:aws:iam::*"]
      }
    ]
  })
}

################################
# IAM Group Policy Attachments #
################################

resource "aws_iam_group_policy_attachment" "mlchen-admin-policy" {
  group      = aws_iam_group.mlchen-admin.name
  policy_arn = aws_iam_policy.mlchen-admin-policy.arn
}

resource "aws_iam_group_policy_attachment" "mlchen-billing-policy" {
  group      = aws_iam_group.mlchen-billing.name
  policy_arn = aws_iam_policy.mlchen-billing-policy.arn
}

resource "aws_iam_group_policy_attachment" "mlchen-developer-policy" {
  group      = aws_iam_group.mlchen-developer.name
  policy_arn = aws_iam_policy.mlchen-admin-policy.arn
}

resource "aws_iam_group_policy_attachment" "mlchen-readonly-policy" {
  group      = aws_iam_group.mlchen-readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "mlchen-team-policy" {
  group      = aws_iam_group.mlchen-team.name
  policy_arn = aws_iam_policy.mlchen-team-policy.arn
}

resource "aws_iam_group_policy_attachment" "mlchen-readonly-local-mfa" {
  group      = aws_iam_group.mlchen-readonly-local.name
  policy_arn = aws_iam_policy.mlchen-staff-allow-mfa-policy.arn
}

resource "aws_iam_group_policy_attachment" "mlchen-readonly-local-readonly" {
  group      = aws_iam_group.mlchen-readonly-local.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "mlchen-staff-admin-policy" {
  group      = aws_iam_group.mlchen-staff-admin.name
  policy_arn = aws_iam_policy.mlchen-admin-local-policy.arn
}

resource "aws_iam_group_policy_attachment" "assume-anyaccount-anyrole-policy" {
  group      = aws_iam_group.assume-anyaccount-anyrole.name
  policy_arn = aws_iam_policy.mlchen-staff-allow-assume-anyaccount-anyrole-policy.arn
}

resource "aws_iam_group_policy_attachment" "assume-mlchen-project-devrole-policy" {
  group      = aws_iam_group.assume-mlchen-project-devrole.name
  policy_arn = aws_iam_policy.mlchen-staff-allow-assume-mlchen-project-devrole-policy.arn
}

#############
# IAM Roles #
#############

locals {
  staff_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::210293595025:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "mlchen-staff-admin" {
  name               = "MLChen-STAFF-Admin"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-Admin" }
}

resource "aws_iam_role" "mlchen-staff-admin-local" {
  name               = "MLChen-STAFF-Admin-Local"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-Admin-Local" }
}

resource "aws_iam_role" "mlchen-staff-billing" {
  name               = "MLChen-STAFF-Billing"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-Billing" }
}

resource "aws_iam_role" "mlchen-staff-developer" {
  name               = "MLChen-STAFF-Developer"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-Developer" }
}

resource "aws_iam_role" "mlchen-staff-readonly" {
  name               = "MLChen-STAFF-ReadOnly"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-ReadOnly" }
}

resource "aws_iam_role" "mlchen-staff-team" {
  name               = "MLChen-STAFF-Team"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "MLChen-STAFF-Team" }
}

###############################
# IAM Role Policy Attachments #
###############################

resource "aws_iam_role_policy_attachment" "mlchen-staff-admin-policy" {
  role       = aws_iam_role.mlchen-staff-admin.name
  policy_arn = aws_iam_policy.mlchen-admin-policy.arn
}

resource "aws_iam_role_policy_attachment" "mlchen-staff-admin-local-policy" {
  role       = aws_iam_role.mlchen-staff-admin-local.name
  policy_arn = aws_iam_policy.mlchen-admin-local-policy.arn
}

resource "aws_iam_role_policy_attachment" "mlchen-staff-billing-policy" {
  role       = aws_iam_role.mlchen-staff-billing.name
  policy_arn = aws_iam_policy.mlchen-billing-policy.arn
}

resource "aws_iam_role_policy_attachment" "mlchen-staff-developer-policy" {
  role       = aws_iam_role.mlchen-staff-developer.name
  policy_arn = aws_iam_policy.mlchen-admin-policy.arn
}

resource "aws_iam_role_policy_attachment" "mlchen-staff-readonly-policy" {
  role       = aws_iam_role.mlchen-staff-readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "mlchen-staff-team-policy" {
  role       = aws_iam_role.mlchen-staff-team.name
  policy_arn = aws_iam_policy.mlchen-team-policy.arn
}
