resource "azurerm_sql_database" "sql_database_cube_activity" {
  name                             = "${var.sqldatabase_cube_activity}"
  resource_group_name              = "${var.group}"
  location                         = "${var.location}"
  server_name                      = "${azurerm_sql_server.sql_server.name}"
  edition                          = "${var.sql_size_edition}"
  requested_service_objective_name = "${var.sql_size_version }"
}

resource "null_resource" "initial_monitoring" {
  depends_on = ["null_resource.allow_access_from_azure_service", "azurerm_sql_database.sql_database_cube_activity"]

  provisioner "local-exec" {
    command = "export SQL_SERVER_HOST=${azurerm_sql_server.sql_server.fully_qualified_domain_name} export SQL_SERVER_USERNAME=${azurerm_sql_server.sql_server.administrator_login} export SQL_SERVER_PASSWORD=${azurerm_sql_server.sql_server.administrator_login_password} export SQL_SERVER_DATABASE_NAME=master export SQL_SCRIPTS=${path.module}/init_monitoring_1.sql && python3.6 ${path.module}/initial_db.py"
  }

  provisioner "local-exec" {
    command = "export SQL_SERVER_HOST=${azurerm_sql_server.sql_server.fully_qualified_domain_name} export SQL_SERVER_USERNAME=${azurerm_sql_server.sql_server.administrator_login} export SQL_SERVER_PASSWORD=${azurerm_sql_server.sql_server.administrator_login_password} export SQL_SERVER_DATABASE_NAME=${var.sqldatabase_cube_activity} export SQL_SCRIPTS=${path.module}/init_cube_activity.sql && python3.6 ${path.module}/initial_db.py"
  }

}

