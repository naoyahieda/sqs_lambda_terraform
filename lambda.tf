// IAM Role for Lambda Function
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = var.service_name
  description        = "IAM Rolw for ${var.service_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_policy" "default" {
  name        = var.service_name
  description = "IAM Policy for ${var.service_name}"
  policy      = file("${var.service_name}_policy.json")
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

// Lambda Function Resources
resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${var.service_name}"
  retention_in_days = 7
}

data archive_file "default" {
  type        = "zip"
  source_dir  = "src"
  output_path = var.output_path
}

resource "aws_lambda_function" "default" {
  filename         = var.output_path
  function_name    = var.service_name
  role             = aws_iam_role.default.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.default.output_base64sha256
  runtime          = "python3.8"
  depends_on = [
    null_resource.main
  ]
  
  # 環境変数を追加するならこう
  environment {
    variables = {
      SLACK_API_KEY = var.SLACK_API_KEY
    }
  }
}
# 重要と思われる
resource "null_resource" "main" {}