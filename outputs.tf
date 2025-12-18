###########
# Outputs #
###########

# VPC Outputs
output "main_vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}

output "main_vpc_cidr" {
  description = "Main VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "utility_vpc_id" {
  description = "Utility VPC ID"
  value       = aws_vpc.utility.id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
}

output "rds_subnet_ids" {
  description = "RDS subnet IDs"
  value = [
    aws_subnet.rds-1.id,
    aws_subnet.rds-2.id,
    aws_subnet.rds-3.id
  ]
}

output "db_subnet_group_name" {
  description = "RDS DB subnet group name"
  value       = aws_db_subnet_group.db-subnet-group.name
}

# Security Group Outputs
output "web_elb_security_group_id" {
  description = "Web ELB security group ID"
  value       = aws_security_group.web-elb.id
}

output "web_server_security_group_id" {
  description = "Web server security group ID"
  value       = aws_security_group.web-server.id
}

output "rds_mysql_security_group_id" {
  description = "RDS MySQL security group ID"
  value       = aws_security_group.rds-mysql.id
}

# VPC Peering Output
output "vpc_peering_connection_id" {
  description = "VPC Peering Connection ID"
  value       = aws_vpc_peering_connection.utility.id
}

# S3 Bucket Outputs
output "s3_bucket_ids" {
  description = "S3 bucket IDs"
  value       = { for k, v in aws_s3_bucket.buckets : k => v.id }
}

# S3 App User Access Keys (for buckets with app_user defined)
output "s3_app_access_keys" {
  description = "S3 app user access key IDs"
  value       = { for k, v in aws_iam_access_key.s3_app : k => v.id }
}

output "s3_app_secret_keys" {
  description = "S3 app user secret access keys"
  value       = { for k, v in aws_iam_access_key.s3_app : k => v.secret }
  sensitive   = true
}

# Route53 Zone Outputs
output "route53_zone_ids" {
  description = "Route53 hosted zone IDs"
  value       = { for k, v in aws_route53_zone.zones : k => v.zone_id }
}

output "route53_name_servers" {
  description = "Route53 name servers"
  value       = { for k, v in aws_route53_zone.zones : k => v.name_servers }
}
