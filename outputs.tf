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
