# Latest ECS-optimized Amazon Linux 2023 AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

# EC2 Launch Template
resource "aws_launch_template" "ecs" {
  name_prefix   = "dnyanarambh-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t3.small"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }


  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.ecs.id
    ]
  }


  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
  EOF
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "dnyanarambh-ecs-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "dnyanarambh-ecs-volume"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs" {
  name             = "dnyanarambh-ecs-asg"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "dnyanarambh-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
