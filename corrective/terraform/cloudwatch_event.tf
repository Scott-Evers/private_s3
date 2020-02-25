resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.correct.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.corrective_control.arn
}
resource "aws_cloudwatch_event_rule" "corrective_control" {
  name        = "correct"
  description = "Trigger lambda remediate public bucket"
  event_pattern = <<EOF
	{
        "source": [
            "aws.config"
        ],
        "detail": {
            "configRuleName": [
                "private_bucket_check"
            ],
            "newEvaluationResult": {
                "complianceType": [
                    "NON_COMPLIANT"
                ]
            }
        }
    }
EOF
}
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.corrective_control.name
  target_id = "InvokeLambda"
  arn       = aws_lambda_function.correct.arn
}


