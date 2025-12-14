###########
# Subnets #
###########

#############################
# Main VPC - Public Subnets #
#############################
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block.public_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Public-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block.public_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Public-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block.public_3
  availability_zone       = var.availability_zone_3
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Public-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############################
# Main VPC - Private Subnets #
##############################
resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.private_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Private-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.private_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Private-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private-3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.private_3
  availability_zone = var.availability_zone_3

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Private-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

##########################
# Main VPC - RDS Subnets #
##########################
resource "aws_subnet" "rds-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.rds_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-RDS-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "rds-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.rds_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-RDS-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "rds-3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block.rds_3
  availability_zone = var.availability_zone_3

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-RDS-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

################################
# Utility VPC - Public Subnets #
################################
resource "aws_subnet" "utility-public-1" {
  vpc_id                  = aws_vpc.utility.id
  cidr_block              = var.utility_cidr_block.public_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Public-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-public-2" {
  vpc_id                  = aws_vpc.utility.id
  cidr_block              = var.utility_cidr_block.public_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Public-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-public-3" {
  vpc_id                  = aws_vpc.utility.id
  cidr_block              = var.utility_cidr_block.public_3
  availability_zone       = var.availability_zone_3
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Public-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#################################
# Utility VPC - Private Subnets #
#################################
resource "aws_subnet" "utility-private-1" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.private_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Private-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-private-2" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.private_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Private-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-private-3" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.private_3
  availability_zone = var.availability_zone_3

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Private-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#############################
# Utility VPC - RDS Subnets #
#############################
resource "aws_subnet" "utility-rds-1" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.rds_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-RDS-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-rds-2" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.rds_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-RDS-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "utility-rds-3" {
  vpc_id            = aws_vpc.utility.id
  cidr_block        = var.utility_cidr_block.rds_3
  availability_zone = var.availability_zone_3

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-RDS-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}
