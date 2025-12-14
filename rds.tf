####################
# RDS Subnet Group #
####################

resource "aws_db_subnet_group" "db-subnet-group" {
  name        = "${var.proj_name.lowercase}-${var.env_name.lowercase}-db-subnets"
  description = "${var.proj_name.main}-${var.env_name.main}-DB-Subnets"
  subnet_ids  = [aws_subnet.rds-1.id, aws_subnet.rds-2.id, aws_subnet.rds-3.id]

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-DB-Subnets"
  }

  lifecycle {
    create_before_destroy = true
  }
}
