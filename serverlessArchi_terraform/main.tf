
provider "aws" {
  region = "eu-west-3" # Paris
}

module "my_lambda" {
  source = "./lambdaFunction"
}




module "my_apigw" {
  source                    = "./apigw"
  lambda_invoke_arn          = module.my_lambda.lambda_invoke_arn
  lambda_function_name       = module.my_lambda.lambda_function_name
  cognito_user_pool_arn      = module.cognito.user_pool_arn
}

module "cognito" {
  source = "./cognito"
}

module "cloudwatch" {
  source               = "./cloudwatch"
  lambda_function_name = module.my_lambda.lambda_function_name
  retention_days       = 30
  environment           = "dev"
}


output "final_url" {
  value = "${module.my_apigw.invoke_url}/serverless-demo-path"
}