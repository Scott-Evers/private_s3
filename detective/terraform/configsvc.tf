resource "aws_s3_bucket" "config_bucket" {
  bucket = "config-bucket-${data.aws_caller_identity.current.account_id}"
}
resource "aws_s3_bucket_public_access_block" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}
resource "aws_iam_role" "config_recorder_role" {
  name = "config_recorder_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy" "config_policy" {
  name = "config_policy"
  role = aws_iam_role.config_recorder_role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.config_bucket.arn}",
        "${aws_s3_bucket.config_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}
resource "aws_iam_policy_attachment" "config_role_attachment" {
  name       = "aws-managed-policy"
  roles      = [aws_iam_role.config_recorder_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}



resource "aws_config_configuration_recorder" "this_region" {
  name                              = "this_region"
  role_arn                          = aws_iam_role.config_recorder_role.arn
  recording_group {
    all_supported                     = "true"
    include_global_resource_types     = "true"
  }
}
resource "aws_config_delivery_channel" "local_account_config_bucket" {
  name           = "local_account_config_bucket"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  depends_on     = [aws_config_configuration_recorder.this_region]
}
resource "aws_config_configuration_recorder_status" "this_region_status" {
  name       = aws_config_configuration_recorder.this_region.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.local_account_config_bucket]
}



