#######################
# Internet Gateways   #
#######################

# Main VPC IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.proj_name.main}-${var.env_name.main}-Gateway"
  }
}

# Utility VPC IGW
resource "aws_internet_gateway" "utility" {
  vpc_id = aws_vpc.utility.id

  tags = {
    Name = "${var.utility.main}-${var.env_name.main}-Gateway"
  }
}

#######################
# NAT Instance        #
#######################
# 註解保留供未來使用，取消註解後執行 terraform apply 即可建立

# # Ubuntu 24.04 LTS AMI
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical
#
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
#   }
#
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
#
# resource "aws_eip" "nat" {
#   domain = "vpc"
#
#   tags = {
#     Name = "${var.proj_name.main}-${var.env_name.main}-NAT-EIP"
#   }
# }
#
# resource "aws_instance" "nat" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = "t3.micro"
#   subnet_id                   = aws_subnet.public-1.id
#   vpc_security_group_ids      = [aws_security_group.nat.id]
#   key_name                    = aws_key_pair.aws-mlchen.key_name
#   associate_public_ip_address = true
#   source_dest_check           = false # NAT must disable this
#
#   user_data = <<-EOF
#     #!/bin/bash
#     # Enable IP forwarding
#     echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
#     sysctl -p
#
#     # Configure iptables for NAT
#     iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
#
#     # Install iptables-persistent and save rules
#     apt-get update
#     DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
#     netfilter-persistent save
#   EOF
#
#   tags = {
#     Name = "${var.proj_name.main}-${var.env_name.main}-NAT"
#   }
#
#   depends_on = [aws_internet_gateway.main]
# }
#
# resource "aws_eip_association" "nat" {
#   instance_id   = aws_instance.nat.id
#   allocation_id = aws_eip.nat.id
# }
