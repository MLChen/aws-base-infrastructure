################
# EC2 Key Pairs #
################

resource "aws_key_pair" "keys" {
  for_each = var.key_pairs

  key_name = each.value
  # public_key 無法從 AWS API 取得，import 後 Terraform 以 AWS 現有狀態為準
  public_key = ""

  tags = {
    Name = each.value
  }

  lifecycle {
    ignore_changes = [public_key]
  }
}
