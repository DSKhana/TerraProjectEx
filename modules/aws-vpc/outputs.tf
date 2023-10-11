output "EC2_Pub_IP" {
  value       = aws_eip.BastionHost_eip.public_ip
  description = "EC2 Instance Public IP Address"
}

output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "vpc_id"
}

output "public_subnet1" {
  value       = aws_subnet.my_vpc_public_subnet1.id
  description = "public_subnet1"
}

output "public_subnet2" {
  value       = aws_subnet.my_vpc_public_subnet2.id
  description = "public_subnet2"
}

output "private_subnet1" {
  value       = aws_subnet.my_vpc_private_subnet1.id
  description = "private_subnet1"
}

output "private_subnet2" {
  value       = aws_subnet.my_vpc_private_subnet2.id
  description = "private_subnet2"
}