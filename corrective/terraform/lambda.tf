resource "aws_iam_role" "lambda_correct" {
  name = "lambda_correct"
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
resource "aws_iam_role_policy" "lambda_correct" {
  name = "lambda_correct"
  role = aws_iam_role.lambda_correct.id
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
                "arn:aws:logs:*:*:log-group:/aws/lambda/remediator:*"
            ]
        },        
        {
            "Effect": "Allow",
            "Action": [
              "s3:PutBucketPublicAccessBlock"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}
resource "aws_lambda_function" "correct" {
  filename      = "lambda.zip"
  function_name = "remediator"
  role          = aws_iam_role.lambda_correct.arn
  handler       = "index.handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime = "nodejs12.x"
}
