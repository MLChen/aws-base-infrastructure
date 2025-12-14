##################
# Route 53 Zones #
##################

# mlchen.org
resource "aws_route53_zone" "mlchen-org" {
  name = "mlchen.org"

  tags = {
    Name = "mlchen.org"
  }
}

# misswu.org
resource "aws_route53_zone" "misswu-org" {
  name = "misswu.org"

  tags = {
    Name = "misswu.org"
  }
}
