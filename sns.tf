##############
# SNS Topics #
##############

resource "aws_sns_topic" "topics" {
  for_each = var.sns_topics

  name = each.value

  tags = {
    Name = each.value
  }
}
