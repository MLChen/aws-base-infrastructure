###################
# Security Groups #
###################

# Admin CIDR
resource "aws_security_group" "admin-cidr" {
  vpc_id      = aws_vpc.main.id
  name        = "Admin-CIDR-${var.admin_cidr_block.company}"
  description = "Admin-CIDR"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = split(",", var.admin_cidr_block.company_cidr)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Admin-CIDR-${var.admin_cidr_block.company}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Web-ELB
resource "aws_security_group" "web-elb" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-Web-ELB"
  description = "Users access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Web-ELB"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2-Instance-Private
resource "aws_security_group" "ec2-instance-private" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-EC2-Instance-Private"
  description = "All EC2 instances"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web-elb.id, aws_security_group.admin-cidr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-EC2-Instance-Private"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.admin-cidr]
}

# Web-Server
resource "aws_security_group" "web-server" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-Web-Server"
  description = "Web Server"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-elb.id, aws_security_group.admin-cidr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Web-Server"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.admin-cidr]
}

# Web-Server-Public
resource "aws_security_group" "web-server-pubilc" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-Web-Server-Public"
  description = "Web Server Public"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Web-Server-Public"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# RDS-MySQL
resource "aws_security_group" "rds-mysql" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-RDS-MySQL"
  description = "Web MySQL Databases"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web-server.id, aws_security_group.admin-cidr.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.utility_cidr_block.main]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-RDS-MySQL"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.admin-cidr]
}

# NAT
resource "aws_security_group" "nat" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.proj_name.main}-${var.env_name.main}-NAT"
  description = "NAT"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web-elb.id, aws_security_group.admin-cidr.id]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-NAT"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.admin-cidr]
}
