variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "family" {
  description = "The family of the ECS task definition"
  type        = string
}

variable "aws_ecs_cluster" {
  description = "ECS cluster"
  type        = string
}

variable "aws_ecs_service" {
  description = "ECS service"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "dd_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "dd_service" {
  description = "Datadog service"
  type        = string
}

variable "host" {
  description = "The host for the Datadog logs"
  type        = string
  default     = "http-intake.logs.datadoghq.com"
}

variable "aws_tags" {
  description = "AWS tags for the Datadog service"
  type        = map(string)
}
