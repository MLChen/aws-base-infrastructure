######################
# VPC Peering        #
######################

resource "aws_vpc_peering_connection" "utility" {
  peer_owner_id = var.utility.account
  peer_vpc_id   = aws_vpc.utility.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = {
    Name = "${var.utility.main} <=> ${var.proj_name.main}-${var.env_name.main}"
  }
}
