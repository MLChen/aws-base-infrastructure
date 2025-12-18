#############
# IAM Users #
#############

resource "aws_iam_user" "users" {
  for_each = var.iam_users

  name = each.key
  tags = { Name = each.key }
}

resource "aws_iam_access_key" "users" {
  for_each = { for k, v in var.iam_users : k => v if v.create_access_key }

  user = aws_iam_user.users[each.key].name
}

# User -> Managed Policy Attachments
resource "aws_iam_user_policy_attachment" "managed" {
  for_each = {
    for item in flatten([
      for user_key, user in var.iam_users : [
        for policy_arn in user.managed_policies : {
          key        = "${user_key}-${md5(policy_arn)}"
          user       = user_key
          policy_arn = policy_arn
        }
      ]
    ]) : item.key => item
  }

  user       = aws_iam_user.users[each.value.user].name
  policy_arn = each.value.policy_arn
}

# User -> Group Memberships
resource "aws_iam_user_group_membership" "users" {
  for_each = { for k, v in var.iam_users : k => v if length(v.groups) > 0 }

  user   = aws_iam_user.users[each.key].name
  groups = [for g in each.value.groups : aws_iam_group.groups[g].name]
}

##############
# IAM Groups #
##############

resource "aws_iam_group" "groups" {
  for_each = var.iam_groups

  name = "${var.proj_name.main}-${each.key}"
}

################################
# IAM Group Policy Attachments #
################################

# Map policy types to their ARNs
locals {
  group_policy_map = {
    admin         = aws_iam_policy.admin.arn
    billing       = aws_iam_policy.billing.arn
    developer     = aws_iam_policy.admin.arn
    readonly      = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    team          = aws_iam_policy.team.arn
    readonly-local = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    staff-admin   = aws_iam_policy.admin-local.arn
    assume-any    = aws_iam_policy.assume-anyaccount-anyrole.arn
    assume-project = aws_iam_policy.assume-project-devrole.arn
  }
}

resource "aws_iam_group_policy_attachment" "groups" {
  for_each = var.iam_groups

  group      = aws_iam_group.groups[each.key].name
  policy_arn = local.group_policy_map[each.value.policy_type]
}

# Additional MFA policy for readonly-local groups
resource "aws_iam_group_policy_attachment" "readonly-local-mfa" {
  for_each = { for k, v in var.iam_groups : k => v if v.policy_type == "readonly-local" }

  group      = aws_iam_group.groups[each.key].name
  policy_arn = aws_iam_policy.staff-allow-mfa.arn
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
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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

  role_policy_map = {
    admin       = aws_iam_policy.admin.arn
    admin-local = aws_iam_policy.admin-local.arn
    billing     = aws_iam_policy.billing.arn
    developer   = aws_iam_policy.admin.arn
    readonly    = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    team        = aws_iam_policy.team.arn
  }
}

resource "aws_iam_role" "staff" {
  for_each = var.iam_staff_roles

  name               = "${var.proj_name.main}-STAFF-${each.key}"
  assume_role_policy = local.staff_assume_role_policy
  tags               = { Name = "${var.proj_name.main}-STAFF-${each.key}" }
}

resource "aws_iam_role_policy_attachment" "staff" {
  for_each = var.iam_staff_roles

  role       = aws_iam_role.staff[each.key].name
  policy_arn = local.role_policy_map[each.value.policy_type]
}

################
# IAM Policies #
################

resource "aws_iam_policy" "admin" {
  name        = "${var.proj_name.main}-Admin-Policy"
  description = "${var.proj_name.main} Admin Policy"
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

resource "aws_iam_policy" "admin-local" {
  name        = "${var.proj_name.main}-Admin-Local-Policy"
  description = "${var.proj_name.main} Admin Local Policy"
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

resource "aws_iam_policy" "billing" {
  name        = "${var.proj_name.main}-Billing-Policy"
  description = "${var.proj_name.main} Billing Policy"
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

resource "aws_iam_policy" "team" {
  name        = "${var.proj_name.main}-Team-Policy"
  description = "${var.proj_name.main} Team Policy"
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

resource "aws_iam_policy" "staff-allow-mfa" {
  name        = "${var.proj_name.main}-STAFF-Allow-MFA-Policy"
  description = "${var.proj_name.main} STAFF Allow MFA Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowMFAManagement"
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

resource "aws_iam_policy" "assume-anyaccount-anyrole" {
  name        = "${var.proj_name.main}-STAFF-Allow-Assume-AnyAccount-AnyRole-Policy"
  description = "${var.proj_name.main} STAFF Allow Assume AnyAccount AnyRole Policy"
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

resource "aws_iam_policy" "assume-project-devrole" {
  name        = "${var.proj_name.main}-STAFF-Allow-Assume-${var.proj_name.main}-Project-DevRole-Policy"
  description = "${var.proj_name.main} STAFF Allow Assume ${var.proj_name.main} Project DevRole Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowAssumeDevRole"
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = ["arn:aws:iam::*"]
      }
    ]
  })
}

#################################
# S3 Bucket App User (from s3_buckets variable) #
#################################

# Create IAM users for S3 bucket apps
resource "aws_iam_user" "s3_app" {
  for_each = { for k, v in var.s3_buckets : k => v.app_user if v.app_user != null }

  name = each.value.name
  tags = { Name = each.value.name }
}

resource "aws_iam_access_key" "s3_app" {
  for_each = { for k, v in var.s3_buckets : k => v.app_user if try(v.app_user.create_access_key, false) }

  user = aws_iam_user.s3_app[each.key].name
}

resource "aws_iam_policy" "s3_app" {
  for_each = { for k, v in var.s3_buckets : k => v if v.app_user != null }

  name        = coalesce(each.value.app_user.policy_name, "${each.value.app_user.name}-S3-Policy")
  description = coalesce(each.value.app_user.policy_description, "${each.value.app_user.name} S3 minimal access policy")
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowBucketAccess"
        Effect   = "Allow"
        Action   = each.value.app_user.allowed_actions
        Resource = "arn:aws:s3:::${each.key}/${each.value.app_user.allowed_prefix}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "s3_app" {
  for_each = { for k, v in var.s3_buckets : k => v if v.app_user != null }

  user       = aws_iam_user.s3_app[each.key].name
  policy_arn = aws_iam_policy.s3_app[each.key].arn
}
