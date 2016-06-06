provider "aws" {
  region = "${var.aws_region}"
}

####################
# Base VPC Setting #
####################
resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block.main}"
    instance_tenancy = "default"
    enable_dns_support  = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

#######################
# Utility VPC Setting #
#######################
resource "aws_vpc" "utility" {
    cidr_block = "${var.utility_cidr_block.main}"
    instance_tenancy = "default"
    enable_dns_support  = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

####################
# Internet Gateway #
####################
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Gateway"
    }
}

resource "aws_internet_gateway" "utility-gw" {
    vpc_id = "${aws_vpc.utility.id}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Gateway"
    }
}

###########
# Subnets #
###########
## Public Subnets
resource "aws_subnet" "public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.public_1}"
    availability_zone = "${var.availability_zone_1}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Public-1"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "public-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.public_2}"
    availability_zone = "${var.availability_zone_2}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Public-2"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "public-3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.public_3}"
    availability_zone = "${var.availability_zone_3}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Public-3"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## Private Subnets
resource "aws_subnet" "private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.private_1}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Private-1"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "private-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.private_2}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Private-2"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "private-3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.private_3}"
    availability_zone = "${var.availability_zone_3}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Private-3"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## RDS Subnets
resource "aws_subnet" "rds-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.rds_1}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-RDS-1"
      }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "rds-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.rds_2}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-RDS-2"
      }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "rds-3" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_block.rds_3}"
    availability_zone = "${var.availability_zone_3}"

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-RDS-3"
      }

    lifecycle {
        create_before_destroy = true
    }
}

## RDS Subnet Groups
resource "aws_db_subnet_group" "db-subnet-group" {
    name = "${var.proj_name.lowercase}-${var.env_name.lowercase}-db-subnets"
    description = "${var.proj_name.main}-${var.env_name.main}-DB-Subnets"
    subnet_ids = ["${aws_subnet.rds-1.id}", "${aws_subnet.rds-2.id}", "${aws_subnet.rds-3.id}"]

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-DB-Subnets"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## Utility Public Subnets
resource "aws_subnet" "utility-public-1" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.public_1}"
    availability_zone = "${var.availability_zone_1}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Public-1"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-public-2" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.public_2}"
    availability_zone = "${var.availability_zone_2}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Public-2"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-public-3" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.public_3}"
    availability_zone = "${var.availability_zone_3}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Public-3"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## Utility Private Subnets
resource "aws_subnet" "utility-private-1" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.private_1}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Private-1"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-private-2" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.private_2}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Private-2"
    }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-private-3" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.private_3}"
    availability_zone = "${var.availability_zone_3}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-Private-3"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## Utility RDS Subnets
resource "aws_subnet" "utility-rds-1" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.rds_1}"
    availability_zone = "${var.availability_zone_1}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-RDS-1"
      }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-rds-2" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.rds_2}"
    availability_zone = "${var.availability_zone_2}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-RDS-2"
      }

    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_subnet" "utility-rds-3" {
    vpc_id = "${aws_vpc.utility.id}"
    cidr_block = "${var.utility_cidr_block.rds_3}"
    availability_zone = "${var.availability_zone_3}"

    tags {
        Name = "${var.utility.main}-${var.env_name.main}-RDS-3"
      }

    lifecycle {
        create_before_destroy = true
    }
}

###################
# Security Groups #
###################
## Admin CIDR
resource "aws_security_group" "admin-cidr" {
    vpc_id = "${aws_vpc.main.id}"
    name = "Admin-CIDR-${var.admin_cidr_block.company}"
    description = "Admin-CIDR"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["${split(",", var.admin_cidr_block.company_cidr)}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "Admin-CIDR-${var.admin_cidr_block.company}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## Web-ELB
resource "aws_security_group" "web-elb" {
    vpc_id = "${aws_vpc.main.id}"
    name = "${var.proj_name.main}-${var.env_name.main}-Web-ELB"
    description = "Users access"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
      Name = "${var.proj_name.main}-${var.env_name.main}-Web-ELB"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## EC2-Instance
### Private Subnet Instance (Main)
resource "aws_security_group" "ec2-instance-private" {
    vpc_id = "${aws_vpc.main.id}"
    name = "${var.proj_name.main}-${var.env_name.main}-EC2-Instance-Private"
    description = "All EC2 instances"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.web-elb.id}", "${aws_security_group.admin-cidr.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-EC2-Instance-Private"
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = ["aws_security_group.admin-cidr"]
}

## Web-Server
resource "aws_security_group" "web-server" {
    vpc_id = "${aws_vpc.main.id}"
    name = "${var.proj_name.main}-${var.env_name.main}-Web-Server"
    description = "Web Server"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.web-elb.id}", "${aws_security_group.admin-cidr.id}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Web-Server"
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = ["aws_security_group.admin-cidr"]

}

## Web Server Public
resource "aws_security_group" "web-server-pubilc" {
    vpc_id = "${aws_vpc.main.id}"
    name = "${var.proj_name.main}-${var.env_name.main}-Web-Server-Public"
    description = "Web Server Public"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Web-Server-Public"
    }

    lifecycle {
        create_before_destroy = true
    }
}

## RDS-MySQL
resource "aws_security_group" "rds-mysql" {
    vpc_id = "${aws_vpc.main.id}"
    name = "${var.proj_name.main}-${var.env_name.main}-RDS-MySQL"
    description = "Web MySQL Databases"

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web-server.id}", "${aws_security_group.admin-cidr.id}"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.utility_cidr_block.main}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-RDS-MySQL"
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = ["aws_security_group.admin-cidr"]

}

## NAT
resource "aws_security_group" "nat" {
      vpc_id = "${aws_vpc.main.id}"
      name = "${var.proj_name.main}-${var.env_name.main}-NAT"
      description = "NAT"

      ingress  {
            from_port = 0
            to_port = 0
            protocol = "-1"
            security_groups = ["${aws_security_group.web-elb.id}", "${aws_security_group.admin-cidr.id}"]
      }
      ingress {
            from_port = -1
            to_port = -1
            protocol = "icmp"
            cidr_blocks =  ["0.0.0.0/0"]
      }
      egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
      }

      tags {
            Name = "${var.proj_name.main}-${var.env_name.main}-NAT"
      }

      lifecycle {
            create_before_destroy = true
      }

    depends_on = ["aws_security_group.admin-cidr"]

}

################
# NAT Gateways #
################
resource "aws_eip" "nat_eip" {
    vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public-1.id}"

    depends_on = ["aws_internet_gateway.gw"]
}

# ######################
# Peering Connections #
# ######################
resource "aws_vpc_peering_connection" "utility" {
        peer_owner_id = "${var.utility.account}"
        peer_vpc_id = "${aws_vpc.utility.id}"
        vpc_id = "${aws_vpc.main.id}"
        auto_accept = "true"

        tags {
            Name = "${var.utility.main} <=> ${var.proj_name.main}-${var.env_name.main}"
         }
}

################
# Route Tables #
################
# Private Table
resource "aws_route_table" "private" {
      vpc_id = "${aws_vpc.main.id}"
      route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
      }
      route {
            cidr_block = "${var.utility_cidr_block.main}"
            vpc_peering_connection_id = "${aws_vpc_peering_connection.utility.id}"
      }

      tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Private-Route"
  }
}

resource "aws_main_route_table_association" "main" {
      vpc_id = "${aws_vpc.main.id}"
      route_table_id = "${aws_route_table.private.id}"

      depends_on = ["aws_route_table.private"]
}

# Public Table
resource "aws_route_table" "public" {
      vpc_id = "${aws_vpc.main.id}"
      route {
            cidr_block = "0.0.0.0/0"
            gateway_id = "${aws_internet_gateway.gw.id}"
      }
      route {
            cidr_block = "${var.utility_cidr_block.main}"
            vpc_peering_connection_id = "${aws_vpc_peering_connection.utility.id}"
      }

      tags {
        Name = "${var.proj_name.main}-${var.env_name.main}-Public-Route"
      }

      depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table_association" "public-1" {
      subnet_id = "${aws_subnet.public-1.id}"
      route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-2" {
      subnet_id = "${aws_subnet.public-2.id}"
      route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-3" {
      subnet_id = "${aws_subnet.public-3.id}"
      route_table_id = "${aws_route_table.public.id}"
}

# Utility Private Table
resource "aws_route_table" "utility-private" {
      vpc_id = "${aws_vpc.utility.id}"
      route {
            cidr_block = "${var.cidr_block.main}"
            vpc_peering_connection_id = "${aws_vpc_peering_connection.utility.id}"
      }
      tags {
        Name = "${var.utility.main}-${var.env_name.main}-Private-Route"
  }
}

# Utility Public Table
resource "aws_route_table" "utility-public" {
      vpc_id = "${aws_vpc.utility.id}"
      route {
            cidr_block = "0.0.0.0/0"
            gateway_id = "${aws_internet_gateway.utility-gw.id}"
      }
      route {
            cidr_block = "${var.cidr_block.main}"
            vpc_peering_connection_id = "${aws_vpc_peering_connection.utility.id}"
      }

      tags {
        Name = "${var.utility.main}-${var.env_name.main}-Public-Route"
      }

      depends_on = ["aws_internet_gateway.utility-gw"]
}

resource "aws_route_table_association" "utility-public-1" {
      subnet_id = "${aws_subnet.utility-public-1.id}"
      route_table_id = "${aws_route_table.utility-public.id}"
}

resource "aws_route_table_association" "utility-public-2" {
      subnet_id = "${aws_subnet.utility-public-2.id}"
      route_table_id = "${aws_route_table.utility-public.id}"
}

resource "aws_route_table_association" "utility-public-3" {
      subnet_id = "${aws_subnet.utility-public-3.id}"
      route_table_id = "${aws_route_table.utility-public.id}"
}

# resource "aws_main_route_table_association" "utility" {
#       vpc_id = "${aws_vpc.utility.id}"
#       route_table_id = "${aws_route_table.utility-public.id}"

#       depends_on = ["aws_route_table.utility-public"]
# }

resource "aws_main_route_table_association" "utility" {
      vpc_id = "${aws_vpc.utility.id}"
      route_table_id = "${aws_route_table.utility-private.id}"

      depends_on = ["aws_route_table.utility-private"]
}
