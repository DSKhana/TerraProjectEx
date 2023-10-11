// 테스트를 위해 ALB에 할당되는 Domain Name 출력 Output 정의
output "ALB_DNS" {
  value       = aws_lb.my_alb.dns_name
  description = "Load Balancer Domain Name"
}

output "ALB_TG" {
  value       = aws_lb_target_group.my_alb_tg.arn
  description = "Load Balancer Targer Group ARN"
}

/* 
output "vpc_id" {
  value       = module.stage_vpc.vpc_id
  description = "VPC_ID"
}

output "name" {
  value       = module.aws_alb.name
  description = "alb_name"
}

output "public_subnets" {
  value = module.aws_alb.public_subnets
  description = "public_subnets"
}

output "HTTP_HTTPS_SG_ID" {
  value = module.aws_alb.HTTP_HTTPS_SG_ID
} */