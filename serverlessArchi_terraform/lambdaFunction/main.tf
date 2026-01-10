data "archive_file" "python_zip_file" {
  type = "zip"
  source_file = "python/getpi.py"
  output_path = "python/getpi.zip"
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = file("lambda-policy.json")
  name = "lambda_role"
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "demolambdafunc"
  filename = "python/getpi.zip"
  role = aws_iam_role.lambda_role.arn
  handler = "getpi.lambda_handler"
  runtime = "python3.9"
  timeout = 30 
}