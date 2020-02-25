resource "aws_organizations_policy_attachment" "root" {
  policy_id = aws_organizations_policy.public_access.id
  target_id = data.aws_organizations_organization.myorg.roots.0.id
  provider  = aws.root
}
resource "aws_organizations_policy" "public_access" {
  name        = "public_access"
  depends_on  = [aws_s3_account_public_access_block.public_block]
  provider    = aws.root
  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Deny",
    "Action": "s3:PutAccountPublicAccessBlock",
    "Resource": "*"
  }
}
CONTENT
}