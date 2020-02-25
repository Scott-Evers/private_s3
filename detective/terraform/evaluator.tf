resource "aws_iam_role" "evaluator" {
  name = "evaluator"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "evaluator" {
  name = "evaluator"
  role = aws_iam_role.evaluator.id
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
      {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/lambda/evaluator:*"
            ]
        },
      {
            "Effect": "Allow",
            "Action": [
                "config:PutEvaluations"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
resource "aws_lambda_function" "evaluator" {
  filename      = "lambda.zip"
  function_name = "evaluator"
  role          = aws_iam_role.evaluator.arn
  handler       = "evaluator.handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime = "nodejs12.x"
}
resource "aws_lambda_permission" "allow_config" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.evaluator.function_name
  principal     = "config.amazonaws.com"
}
resource "aws_sns_topic" "security_notify" {
  name        = "security_notify"
}
