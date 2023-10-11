data "aws_key_pair" "EC2-Key" {
  key_name = "EC2-key"
}

resource "aws_launch_configuration" "aws_asg_launch" {
  name            = "${var.name}-asg-launch"
  image_id        = "ami-0ea4d4b8dc1e46212"
  instance_type   = var.instance_type
  key_name        = data.aws_key_pair.EC2-Key.key_name
  security_groups = [var.SSH_SG_ID, var.HTTP_HTTPS_SG_ID]
  user_data       = <<-EOF
  #!/bin/bash
  yum -y update
  yum -y install http.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "DB Endpoint: ${data.terraform_remote_state.rds_remote_data.outputs.rds_instance_address}" > /var/www/html/index.html
	echo "DB port: ${data.terraform_remote_state.rds_remote_data.outputs.rds_instance_port}" >> /var/www/html/index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws_asg" {
  name                 = "${var.name}-asg"
  launch_configuration = aws_launch_configuration.aws_asg_launch.name
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.private_subnets

  target_group_arns    = [data.terraform_remote_state.app1_remote_data.outputs.ALB_TG]
  health_check_type    = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  min_elb_capacity = var.min_size

  tag {
    key                 = "Name"
    value               = "${var.name}_Terraform_Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "aws_asg_policy_out" {
  name                   = "${var.name}-asg-policy-out"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.aws_asg.name
}

resource "aws_cloudwatch_metric_alarm" "aws_asg_cpu_alert_out" {
  alarm_name          = "${var.name}_asg_cpu-alarm-scaleout"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  namespace           = "AWS/EC2"
  threshold           = 70
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws_asg.name
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.aws_asg_policy_out.arn]
}

resource "aws_autoscaling_policy" "aws_asg_policy_in" {
  name                   = "${var.name}-asg-policy-in"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_policy.aws_asg_policy_out.name
}

resource "aws_cloudwatch_metric_alarm" "aws_asg_cpu_alarm_in" {
  alarm_name          = "${var.name}_asg_cpu_alarm_scalein"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  namespace           = "AWS/EC2"
  threshold           = 10
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws_asg.name
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.aws_asg_policy_in.arn]
}