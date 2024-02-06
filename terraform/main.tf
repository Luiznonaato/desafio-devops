# VPC
resource "aws_vpc" "meu_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MinhaVPC"
  }
}

output "vpc_id" {
  value = aws_vpc.meu_vpc.id
}

# Subnet
resource "aws_subnet" "subnet_id" {
  vpc_id            = aws_vpc.meu_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  

  tags = {
    Name = "subnet_id"
  }
}

# Output para a Subnet
output "subnet_id" {
  value = aws_subnet.subnet_id.id
}

resource "aws_instance" "aami_id" {
  ami           = var.aami_id
  instance_type = "t2.micro"
  // Adicione mais configurações conforme necessário
}
output "aami_id" {
  value       = var.aami_id
}

# Security Group para o ALB e ECS
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.meu_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
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

resource "aws_ecs_service" "meu_servico_ecs" {
  name            = "meu-servico-ecs"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.meu_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.subnet_id.id] # Corrigido aqui
    security_groups = [aws_security_group.sg.id]
    assign_public_ip = true
  }
}
# Cluster ECS
resource "aws_ecs_cluster" "cluster" {
  name = "seu-cluster-ecs"  # Substitua pelo nome desejado do cluster ECS
}

output "ecs_service_name" {
  value = aws_ecs_service.meu_servico_ecs.name
}


# Respositorio
resource "aws_ecr_repository" "repositorio" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
}
output "ecr_repository_url" {
  value = aws_ecr_repository.repositorio.repository_url
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "meu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.subnet_id.id] # Corrigido aqui
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.meu_vpc.id

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

# Launch Template para instâncias ECS
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-launch-template-"
  image_id      = var.aami_id
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


/*

# Data source para a zona do Route53
data "aws_route53_zone" "selected" {
  name = var.zone_name
}

# Recurso para o registro no Route53
resource "aws_route53_record" "desafio_devops" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

*/
