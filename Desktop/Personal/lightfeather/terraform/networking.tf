# VPC Creation
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "ecs-vpc"
  }
}

# Subnet Creation
resource "aws_subnet" "ecs_subnet" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs-subnet"
  }
}

# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow ECS traffic"
  vpc_id      = aws_vpc.ecs_vpc.id
}

# Allow HTTP traffic to ECS service
resource "aws_security_group_rule" "allow_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}



# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster"
}

# IAM Roles for ECS
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# Define ALB (Optional) for routing traffic to ECS services (frontend and backend)
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.ecs_subnet.id]

  enable_deletion_protection = false
#   idle_timeout {
#     timeout_seconds = 60
#   }

  tags = {
    Name = "ecs-alb"
  }
}
