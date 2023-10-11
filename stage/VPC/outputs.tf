output "vpc_id" {
  value       = module.stage_vpc.vpc_id
  description = "VPC_ID"
}

// ip주소가 아니라 id값으로 가져와짐
output "public_subnets" {
  value       = module.stage_vpc.public_subnets
  description = "Public Subnets (List)"
}

output "private_subnets" {
  value       = module.stage_vpc.private_subnets
  description = "Private Subnets (List)"
}

output "ssh_sg_id" {
  value       = module.SSH_Security_group.security_group_id
  description = "SSH Security Group ID"
}

output "alb_sg_id" {
  value       = module.ALB_Security_group.security_group_id
  description = "ALB Security Group ID"
}