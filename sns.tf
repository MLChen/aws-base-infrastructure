##############
# SNS Topics #
##############

resource "aws_sns_topic" "majord-shop" {
  name = "MajorD-Shop"

  tags = {
    Name = "MajorD-Shop"
  }
}
