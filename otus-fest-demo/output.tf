output "sqlserver_host" {
  value = "${module.azure_sql.sqlserver_host}"
}

output "sqlserver_user" {
  value = "${var.sqluser}"
}

output "sqlserver_password" {
  value = "_${random_id.password_sql.hex}"
}

output "storage_connection" {
  value = "${module.storage.storage_primary_connection_string}"
}

output "event_hub_connection" {
  value = "${module.event_hub.event_hub_connection}"
}