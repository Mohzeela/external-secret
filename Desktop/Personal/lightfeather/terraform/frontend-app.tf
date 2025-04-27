# Frontend ECS Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "frontend"
    image     = "992382778146.dkr.ecr.us-east-1.amazonaws.com/frontend:latest"  # Replace with your frontend Docker image URL
    essential = true
    portMappings = [
      {
        containerPort = 80  # Port for frontend service
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}

# Frontend ECS Service
resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.ecs_subnet.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    container_name   = "frontend"
    container_port   = 80
  }
}

# Frontend Load Balancer Target Group
resource "aws_lb_target_group" "frontend_target_group" {
  name     = "frontend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecs_vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "frontend-target-group"
  }
}
