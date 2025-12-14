# AWS Region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

# Project Name
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

# Project Environment
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

# Utility VPC
variable "utility" {
  description = "Utility VPC configuration"
  type = object({
    main    = string
    account = string
  })
  default = {
    main    = "Project-Utility"
    account = "AWS_Account_Number"
  }
}

# Main VPC CIDR Block
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

# Utility VPC CIDR Block
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

# Admin CIDR Block
variable "admin_cidr_block" {
  description = "Admin CIDR block for management access"
  type = object({
    company      = string
    company_cidr = string
  })
  default = {
    company      = "Admin"
    company_cidr = "0.0.0.0/32"  # 請更新為實際管理員 IP
  }
  sensitive = true
}

# Availability Zones
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

