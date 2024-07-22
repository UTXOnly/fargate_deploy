# AWS Configuration
subnet_ids         = ["subnet-<YOUR_SUBNET>"]
security_group_ids = ["sg-<YOUR_SECURITY_GROUP>"]
execution_role_arn = "arn:aws:iam::<YOUR_ACCOUNT_ID>:role/ecsTaskExecutionRole"
task_role_arn      = "arn:aws:iam::<YOUR_ACCOUNT_ID>:role/ecsTaskExecutionRole"
aws_ecs_cluster = "your-name-cluster"
aws_ecs_service = "your-name-service"

# Datadog Configuration
dd_api_key = "your-api-key"
dd_service = "sandbox"
host = "http-intake.logs.datadoghq.com" # Default US1 log intake, can adjust for differnt regions as needed

# ECS Configuration
family = "your_name_sandbox"

# Tags
aws_tags = {
  environment = "sandbox"
  owner       = "your.name"
  team        = "sandbo-team"
}

