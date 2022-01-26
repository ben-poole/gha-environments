variable "region" {
  type        = string
  description = "The region all resources will be created in"
  default     = "eu-west-1"
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "lambda_memory_size" {
  default = "128"
}

variable "lambda_runtime" {
  default = "nodejs14.x"
}

variable "lambda_timeout" {
  default = "10"
}

variable "lambda_reserved_concurrent_executions" {
  default = "10"
}

variable "lambda_s3_bucket_name" {
  type = string
}

variable "lambda_s3_bucket_path" {
  type = string
}