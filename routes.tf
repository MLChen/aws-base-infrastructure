################
# Route Tables #
################

#################################
# Main VPC - Private Route Table
#################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.utility_cidr_block.main
    vpc_peering_connection_id = aws_vpc_peering_connection.utility.id
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Private-Route"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table.private]
}

################################
# Main VPC - Public Route Table
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.utility_cidr_block.main
    vpc_peering_connection_id = aws_vpc_peering_connection.utility.id
  }

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Public-Route"
  }
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public.id
}

####################################
# Utility VPC - Private Route Table
####################################
resource "aws_route_table" "utility-private" {
  vpc_id = aws_vpc.utility.id

  route {
    cidr_block                = var.cidr_block.main
    vpc_peering_connection_id = aws_vpc_peering_connection.utility.id
  }

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Private-Route"
  }
}

resource "aws_main_route_table_association" "utility" {
  vpc_id         = aws_vpc.utility.id
  route_table_id = aws_route_table.utility-private.id

  depends_on = [aws_route_table.utility-private]
}

###################################
# Utility VPC - Public Route Table
###################################
resource "aws_route_table" "utility-public" {
  vpc_id = aws_vpc.utility.id

  route {
    cidr_block                = var.cidr_block.main
    vpc_peering_connection_id = aws_vpc_peering_connection.utility.id
  }

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Public-Route"
  }
}

resource "aws_route_table_association" "utility-public-1" {
  subnet_id      = aws_subnet.utility-public-1.id
  route_table_id = aws_route_table.utility-public.id
}

resource "aws_route_table_association" "utility-public-2" {
  subnet_id      = aws_subnet.utility-public-2.id
  route_table_id = aws_route_table.utility-public.id
}

resource "aws_route_table_association" "utility-public-3" {
  subnet_id      = aws_subnet.utility-public-3.id
  route_table_id = aws_route_table.utility-public.id
}

####################
# Internet Routes  #
####################

# Main VPC Public → Main IGW
resource "aws_route" "main-public-igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Main VPC Private → NAT Instance
# 註解保留供未來使用，取消註解後執行 terraform apply 即可建立
# resource "aws_route" "main-private-nat" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   network_interface_id   = aws_instance.nat.primary_network_interface_id
# }

# Utility VPC Public → Utility IGW
resource "aws_route" "utility-public-igw" {
  route_table_id         = aws_route_table.utility-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.utility.id
}
