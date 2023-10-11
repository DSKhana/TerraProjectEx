output "rds_instance_address" {
  value       = module.app1_db.db_instance_address
  description = "Database Instance Address"
}

output "rds_instance_port" {
  value       = module.app1_db.db_instance_port
  description = "Database Instance Port"
}