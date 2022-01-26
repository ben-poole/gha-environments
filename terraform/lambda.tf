// IAM role which dictates what other AWS services the Lambda function can access
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-lambda-exec-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_basic_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


// log group for the lambda
resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.project_name}-gha-envs-example"
}

// The Lambda function
resource "aws_lambda_function" "user_api" {
  function_name                  = "${var.project_name}-gha-envs-example"
  s3_bucket                      = var.lambda_s3_bucket_name
  s3_key                         = var.lambda_s3_bucket_path
  role                           = aws_iam_role.lambda_exec_role.arn
  memory_size                    = var.lambda_memory_size
  handler                        = "index.handler"
  runtime                        = var.lambda_runtime
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  publish                        = true

  environment {
    variables = {
      APP_VERSION                 = "0.0.1"
      NODE_ENV                    = var.environment
    }
  }

  depends_on = [ aws_cloudwatch_log_group.lambda ]
}

// The current version of the lambda
resource "aws_lambda_alias" "user_alias_latest" {
  name             = "latest"
  description      = "latest version"
  function_name    = aws_lambda_function.user_api.arn
  function_version = aws_lambda_function.user_api.version
}
