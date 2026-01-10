terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.47.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" # Paris
}

module "my_lambda" {
  source = "./lambdaFunction"
}

module "my_apigw" {
  source               = "./apigw"
  lambda_invoke_arn    = module.my_lambda.lambda_invoke_arn
  lambda_function_name = module.my_lambda.lambda_function_name
}

output "final_url" {
  value = "${module.my_apigw.invoke_url}/serverless-demo-path"
}