resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.retention_days

  tags = {
    Application = "safran-engine-analysis"
    Environment = var.environment
  }
}
