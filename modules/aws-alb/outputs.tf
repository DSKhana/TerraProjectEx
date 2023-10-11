// 테스트를 위해 ALB에 할당되는 Domain Name 출력하는 Output 정의
output "ALB_DNS" {
  value       = aws_lb.my_alb.dns_name
  description = "Load Balancer Domain Name"
}

output "ALB_TG" {
  value       = aws_lb_target_group.my_alb_tg.arn
  description = "Load Balancer Targer Group ARN"
}