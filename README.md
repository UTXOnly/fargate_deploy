# fargate_deploy
A simple terraform script to deploy the Datadog agent as a sidecar container in a ECS Fargate task

This deploys:
* `busybox` container that emits logs
* AWS FireLens/fluentbit log driver
* Datadog agent sidecar container

## Prerequisites
* [aws-cli](https://github.com/aws/aws-cli)
* AWS account
* [aws-vault](https://github.com/99designs/aws-vault)

## Configure

Update the variables in the `terraform.tfvars` file to use your own account info and credentials:

```tf
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
```

## Deploy

Once `aws-cli` and `aws-vault` are configured you can deploy this task in 3 steps below

```
terraform init
```

```
aws-vault exec <your_profile_role> -- terraform plan
```

```
aws-vault exec <your_profile_role> -- terraform plan
```
* (enter `yes` when prompted to create the resources)

### Cleanup

```
aws-vault exec <your_profile_role> -- terraform plan
```
