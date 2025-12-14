################
# EC2 Key Pairs #
################

resource "aws_key_pair" "aws-mlchen" {
  key_name = "aws-mlchen"
  # 注意：public_key 需要從現有 key pair 取得或保持原狀
  # 由於 key pair 的 public key 無法從 AWS API 取得，
  # import 後 Terraform 會以 AWS 現有狀態為準
  public_key = ""

  tags = {
    Name = "aws-mlchen"
  }

  lifecycle {
    ignore_changes = [public_key]
  }
}
