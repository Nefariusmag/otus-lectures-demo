output "sqlserver_host" {
  value = "${azurerm_sql_server.sql_server.fully_qualified_domain_name}"
}

output "sqlserver_servername" {
  value = "${azurerm_sql_server.sql_server.name}"
}

output "sqlserver_user" {
  value = "${azurerm_sql_server.sql_server.administrator_login}"
}

output "sqlserver_password" {
  value = "${azurerm_sql_server.sql_server.administrator_login_password}"
}

output "sqlserver_database_cube_activity" {
  value = "${var.sqldatabase_cube_activity}"
}