/*resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "meu_task_definition" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  container_definitions    = var.container_definitions
}

resource "aws_ecs_service" "meu_servico_ecs" {
  name             = var.service_name
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.meu_task_definition.arn
  desired_count    = var.desired_count
  launch_type      = var.launch_type
  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
}

output "ecs_service_name" {
  description = "O nome do serviço ECS criado."
  value       = aws_ecs_service.meu_servico_ecs.name
}
*/
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_ecs_task_definition" "meu_task_definition" {
  family                   = "meu-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "meu-container",
      image     = "seu_repo_docker/sua_imagem:latest",
      cpu       = 256,
      memory    = 512,
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ],
    }
  ])
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "meu_servico_ecs" {
  name            = "meu-servico-ecs"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.meu_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.subnet_id.id] 
    security_groups = [aws_security_group.sg.id]
    assign_public_ip = true
  }
}

# Launch Template para instâncias ECS
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-launch-template-"
  image_id      = var.ami_id
  instance_type = "t3.medium" 

  user_data = base64encode(<<-EOF
  #!/bin/bash
  echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  min_size             = 1
  max_size             = 10
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.subnet_id.id] # Corrigido aqui

  tag {
    key                 = "Server-app"
    value               = "ECS Instance"
    propagate_at_launch = true
  }
}

#Outputs
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.meu_task_definition.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.meu_servico_ecs.name
}

output "launch_template_id" {
  value = aws_launch_template.ecs_launch_template.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs_asg.name
}
