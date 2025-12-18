######################
# Basic Configuration #
######################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "proj_name" {
  description = "Project name in different cases"
  type = object({
    main      = string
    lowercase = string
  })
  default = {
    main      = "Project-Name"
    lowercase = "project-name"
  }
}

variable "env_name" {
  description = "Environment name"
  type = object({
    main      = string
    lowercase = string
  })
  default = {
    main      = "Production"
    lowercase = "production"
  }
}

####################
# VPC Configuration #
####################

variable "utility" {
  description = "Utility VPC configuration"
  type = object({
    main    = string
    account = string
  })
  default = {
    main    = "Project-Utility"
    account = "000000000000"
  }
}

variable "cidr_block" {
  description = "Main VPC CIDR blocks"
  type = object({
    main      = string
    public_1  = string
    public_2  = string
    public_3  = string
    private_1 = string
    private_2 = string
    private_3 = string
    rds_1     = string
    rds_2     = string
    rds_3     = string
  })
  default = {
    main      = "10.0.0.0/16"
    public_1  = "10.0.10.0/24"
    public_2  = "10.0.11.0/24"
    public_3  = "10.0.12.0/24"
    private_1 = "10.0.20.0/24"
    private_2 = "10.0.21.0/24"
    private_3 = "10.0.22.0/24"
    rds_1     = "10.0.30.0/24"
    rds_2     = "10.0.31.0/24"
    rds_3     = "10.0.32.0/24"
  }
}

variable "utility_cidr_block" {
  description = "Utility VPC CIDR blocks"
  type = object({
    main      = string
    public_1  = string
    public_2  = string
    public_3  = string
    private_1 = string
    private_2 = string
    private_3 = string
    rds_1     = string
    rds_2     = string
    rds_3     = string
  })
  default = {
    main      = "10.1.0.0/16"
    public_1  = "10.1.10.0/24"
    public_2  = "10.1.11.0/24"
    public_3  = "10.1.12.0/24"
    private_1 = "10.1.20.0/24"
    private_2 = "10.1.21.0/24"
    private_3 = "10.1.22.0/24"
    rds_1     = "10.1.30.0/24"
    rds_2     = "10.1.31.0/24"
    rds_3     = "10.1.32.0/24"
  }
}

variable "admin_cidr_block" {
  description = "Admin CIDR block for management access"
  type = object({
    company      = string
    company_cidr = string
  })
  default = {
    company      = "Admin"
    company_cidr = "0.0.0.0/32"
  }
  sensitive = true
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "ap-northeast-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "ap-northeast-1c"
}

variable "availability_zone_3" {
  description = "Third availability zone"
  type        = string
  default     = "ap-northeast-1d"
}

####################
# IAM Configuration #
####################

variable "iam_users" {
  description = "IAM users to create"
  type = map(object({
    create_access_key = optional(bool, false)
    groups            = optional(list(string), [])
    managed_policies  = optional(list(string), []) # AWS managed policy ARNs
  }))
  default = {}
}

variable "iam_groups" {
  description = "IAM groups to create (key = group suffix, policy_type = admin|billing|developer|readonly|team|readonly-local|staff-admin|assume-any|assume-project)"
  type = map(object({
    policy_type = string
  }))
  default = {}
}

variable "iam_staff_roles" {
  description = "IAM STAFF roles to create (assumable with MFA)"
  type = map(object({
    policy_type = string # admin|admin-local|billing|developer|readonly|team
  }))
  default = {}
}

###################
# S3 Configuration #
###################

variable "s3_buckets" {
  description = "S3 buckets to create"
  type = map(object({
    versioning          = optional(bool, false)
    block_public_access = optional(bool, true)
    public_read_prefix  = optional(string, null)
    cors = optional(object({
      allowed_origins = list(string)
      allowed_methods = optional(list(string), ["GET"])
      allowed_headers = optional(list(string), ["*"])
      expose_headers  = optional(list(string), [])
    }), null)
    # For app-specific IAM user with bucket access
    app_user = optional(object({
      name               = string
      policy_name        = optional(string, null) # Override policy name (default: {name}-S3-Policy)
      policy_description = optional(string, null) # Override policy description
      allowed_prefix     = string
      allowed_actions    = optional(list(string), ["s3:GetObject", "s3:PutObject"])
      create_access_key  = optional(bool, true)
    }), null)
  }))
  default = {}
}

########################
# Route53 Configuration #
########################

variable "route53_zones" {
  description = "Route53 hosted zones to create (key = zone identifier, value = domain name)"
  type        = map(string)
  default     = {}
}

####################
# SNS Configuration #
####################

variable "sns_topics" {
  description = "SNS topics to create (key = topic identifier, value = topic name)"
  type        = map(string)
  default     = {}
}

####################
# EC2 Configuration #
####################

variable "key_pairs" {
  description = "EC2 key pairs to create (key = identifier, value = key name)"
  type        = map(string)
  default     = {}
}

