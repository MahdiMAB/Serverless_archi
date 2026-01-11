variable "lambda_function_name" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 14
}

variable "environment" {
  type    = string
  default = "dev"
}
