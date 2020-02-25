resource "aws_config_config_rule" "private_buckets" {
  name              = "private_bucket_check"
  input_parameters  = "{}"
  scope {
      compliance_resource_types = ["AWS::S3::Bucket"]
  }
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.evaluator.arn
    source_detail {
      message_type  = "ConfigurationItemChangeNotification"
    }
  }

  depends_on = [aws_config_configuration_recorder.this_region , aws_lambda_permission.allow_config]
}