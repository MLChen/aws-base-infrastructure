##########
# VPCs   #
##########

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block.main
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Utility VPC
resource "aws_vpc" "utility" {
  cidr_block           = var.utility_cidr_block.main
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
