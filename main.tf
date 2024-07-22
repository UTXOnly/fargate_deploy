provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "example" {
  name = var.aws_ecs_cluster
}

resource "aws_ecs_task_definition" "example" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name        = "datadog_agent"
      image       = "public.ecr.aws/datadog/agent:latest"
      cpu         = 0
      essential   = true
      portMappings = [
        {
          name          = "dogstatsd"
          containerPort = 8125
          hostPort      = 8125
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [

        {
          name  = "DD_API_KEY"
          value = var.dd_api_key
        }
      ]
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          dd_message_key = "log"
          apikey         = var.dd_api_key
          provider       = "ecs"
          dd_service     = "firelenstest"
          Host           = "http-intake.logs.datadoghq.com"
          TLS            = "on"
          dd_source      = "datadog_agent"
          Name           = "datadog"
        }
      }
    },
    {
      name        = "application_container"
      image       = "busybox"
      cpu         = 0
      essential   = true
      command     = ["sh", "-c", "for i in $(seq 1 300); do echo '{\"log\":\"fake log data\",\"level\":\"info\"}'; sleep 5; done; exit 1"]
      portMappings = [
        {
          name          = "port-8080"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          dd_message_key = "log"
          apikey         = var.dd_api_key
          provider       = "ecs"
          dd_service     = "firelens-failure-test"
          Host           = "http-intake.logs.datadoghq.com"
          TLS            = "on"
          dd_source      = "application_container"
          Name           = "datadog"
        }
      }
    },
    {
      name        = "log_router"
      image       = "amazon/aws-for-fluent-bit:stable"
      cpu         = 0
      essential   = true
      user        = "0"
      firelensConfiguration = {
        type = "fluentbit"
        options = {
          "config-file-type"         = "file"
          "config-file-value"        = "/fluent-bit/configs/parse-json.conf"
          "enable-ecs-log-metadata"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "example" {
  name            = var.aws_ecs_service
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = true
  }

  tags = var.aws_tags
}
