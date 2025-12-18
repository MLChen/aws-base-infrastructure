##################
# Route 53 Zones #
##################

resource "aws_route53_zone" "zones" {
  for_each = var.route53_zones

  name = each.value

  tags = {
    Name = each.value
  }
}
