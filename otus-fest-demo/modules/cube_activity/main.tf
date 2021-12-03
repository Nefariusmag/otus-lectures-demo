resource "azurerm_app_service_plan" "cube_engine_logs_func_service_plan" {
  name                = "${var.name_azure_func}"
  location            = "${var.location}"
  resource_group_name = "${var.group}"

  kind     = "linux"
  reserved = true

  sku {
    tier = "${var.service_plan_tier}"
    size = "${var.service_plan_size}"
  }
}


resource "azurerm_function_app" "cube_engine_logs_func_app" {
  name                = "${var.name_azure_func}"
  resource_group_name = "${var.group}"
  location            = "${var.location}"

  app_service_plan_id       = "${azurerm_app_service_plan.cube_engine_logs_func_service_plan.id}"
  storage_connection_string = "${var.storage_connection_string}"

  app_settings {
    FUNCTIONS_WORKER_RUNTIME = "python"
    EventHubConnection       = "${var.eventhub_connection}"
    SQL_SERVER_HOST          = "${var.sqlserver_host}"
    SQL_SERVER_DATABASE_NAME = "${var.sqlserver_database}"
    SQL_SERVER_USERNAME      = "${var.sqlserver_user}"
    SQL_SERVER_PASSWORD      = "${var.sqlserver_password}"
    LIST_SERVICE_USER        = "${var.list_service_user}"

    WEBSITE_RUN_FROM_PACKAGE       = ""
    APPINSIGHTS_INSTRUMENTATIONKEY = ""
    WEBSITE_NODE_DEFAULT_VERSION   = "10.14.1"
  }

  https_only = false
}

resource "null_resource" "azure_functions_deploy" {
  depends_on = ["azurerm_function_app.cube_engine_logs_func_app"]

  provisioner "local-exec" {
    command = "sleep 60"
  }
  provisioner "local-exec" {
    command = "cd ${path.module} && func azure functionapp publish ${azurerm_function_app.cube_engine_logs_func_app.name} --python"
  }
}
