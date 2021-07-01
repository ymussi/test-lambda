/* Common */
variable "aws_region" {
  type        = string
  description = "This is the AWS region."
  default     = "us-east-2"
}

variable "environment_name" {
  type        = string
  description = "Application environment name."
  default     = ""
}

variable "app_name" {
  type        = string
  description = "Application name."
  default     = ""
}

variable "app_prefix" {
  type        = string
  description = "Application prefix name. example mickey-portal-de-whatever, would be just mickey"
  default     = ""
}

variable "secrets_name" {
  type        = string
  description = "Application's secrets name. leave it blank to use the default ( app_name+environment_name ) or fill it to override default secrets value,"
  default     = ""
}

variable "commercial_name" {
  type        = string
  description = "Application commercial name."
  default     = ""
}

variable "github_token" {
  type        = string
  description = "Github Token for cloning the project repository. Flags=SENSITIVE"
}

/* CloudWatch */
variable "schedule_expression" {
  type        = string
  description = "You can create rules that self-trigger on an automated schedule in CloudWatch Events using cron or rate expressions."
  default     = "rate(5 minutes)"
}

/* Lambda */
variable "lambda_runtime" {
  type        = string
  description = "Identifier of the function's runtime."
  default     = "nodejs14.x"
}

variable "lambda_handler" {
  type        = string
  description = "Function entrypoint in your code."
  default     = "app.handler"
}

variable "lambda_memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = 128
}

variable "lambda_timeout" {
  type        = number
  description = "The amount of time your Lambda Function has to run in seconds."
  default = 3
}