
locals {
  cluster_name = "Cluster_Bluesoft"
}

################################# ECS

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_capacity_provider" "ec2_capacity_provider" {
  name = "ec2-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.main.arn
    managed_scaling {
      status              = "ENABLED"
      target_capacity     = 75
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 100
    }
   // managed_termination_protection = "DISABLE"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.ec2_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2_capacity_provider.name
    weight            = 1
    base              = 1
  }
}

data "aws_iam_policy_document" "ecs_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs-instance"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  count = var.use_AmazonEC2ContainerServiceforEC2Role_policy ? 1 : 0

  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRole"
  path = "/"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name = "ecs-tasks-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-Bluesoft"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn

  container_definitions = jsonencode([
    {
      name         = "my-container",
      image        = "desafio",
      cpu          = 256,
      memory       = 512,
      essential    = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ],
    }
  ])
}


resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

load_balancer {
    target_group_arn = var.aws_lb_target_group
    container_name   = "my-container"
    container_port   = 80
  }

  network_configuration {
    subnets         = var.subnet_id
    security_groups = var.aws_security_group
  }


  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2_capacity_provider.name
    weight            = 1
    base              = 1
  }
  
   depends_on = [var.aws_lb_listener]
}

################################# EC2

resource "aws_launch_configuration" "main" {
  name_prefix = format("ecs-%s-", local.cluster_name)

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name

  instance_type               = var.instance_type
  image_id                    = "ami-0e731c8a588258d0d"
  associate_public_ip_address = false
  security_groups             = var.aws_security_group

  root_block_device {
    volume_type = "standard"
    volume_size = 10
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "standard"
    volume_size = 10
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
  }
  
  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
              EOF
}

################################# AUTO SCALING

resource "aws_autoscaling_group" "main" {
  name = "ecs-${local.cluster_name}"

  launch_configuration = aws_launch_configuration.main.id
  termination_policies = ["OldestLaunchConfiguration", "Default"]
  vpc_zone_identifier  = var.subnet_id
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ecs-${local.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = local.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Automation"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

