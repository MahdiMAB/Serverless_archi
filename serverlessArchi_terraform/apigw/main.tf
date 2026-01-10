resource "aws_api_gateway_rest_api" "rest_api" {
  name = "rest_api"

  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_resource" "api_resource" {
    parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
    path_part = "serverless-demo-path"
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
  
}

resource "aws_api_gateway_method" "api_method" {
  authorization = "None"
  http_method = "POST"
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  http_method = aws_api_gateway_method.api_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = var.lambda_invoke_arn

}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = "dev"
}

resource "aws_lambda_permission" "lambda_permission" {
    principal = "apigateway.amazonaws.com"
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_function_name
    source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"

}

