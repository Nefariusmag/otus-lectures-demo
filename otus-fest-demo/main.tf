provider "azurerm" {
  version = "=1.44.0"
}

resource "azurerm_resource_group" "bi_group" {
  name     = "${var.group}"
  location = "${var.location}"

  tags {
    env     = "${var.stand}"
    owner   = "${var.owner}"
    project = "serverless"
  }
}

resource "random_id" "password_sql" {
  keepers = {
    resource_group = "${azurerm_resource_group.bi_group.name}"
  }

  byte_length = 16
}

module "storage" {
  source       = "modules/storage"
  group        = "${azurerm_resource_group.bi_group.name}"
  storage_name = "stg${var.stand}${var.number_group}"
}

module "azure_sql" {
  source      = "modules/mssql"
  group       = "${azurerm_resource_group.bi_group.name}"
  location    = "${azurerm_resource_group.bi_group.location}"
  sqluser     = "${var.sqluser}"
  sqlpassword = "_${random_id.password_sql.hex}"

  sql_name         = "azuresql-${var.stand}-${var.number_group}"
  sql_size_edition = "GeneralPurpose"
  sql_size_version = "GP_S_Gen5_1"
}

module "event_hub" {
  source   = "modules/event_hub"
  location = "${azurerm_resource_group.bi_group.location}"
  group    = "${azurerm_resource_group.bi_group.name}"

  name_evenhub = "event-hub-${var.stand}-${var.number_group}"
}

module "cube_activity" {
  source   = "modules/cube_activity"
  location = "${azurerm_resource_group.bi_group.location}"
  group    = "${azurerm_resource_group.bi_group.name}"

  storage_connection_string = "${module.storage.storage_primary_connection_string}"
  sqlserver_host            = "${module.azure_sql.sqlserver_host}"
  sqlserver_database        = "${module.azure_sql.sqlserver_database_cube_activity}"
  sqlserver_user            = "${module.azure_sql.sqlserver_user}"
  sqlserver_password        = "${module.azure_sql.sqlserver_password}"

  name_azure_func     = "azure-funcion-${var.stand}-${var.number_group}-cube-monitor"
  eventhub_connection = "${module.event_hub.event_hub_connection}"
  service_plan_tier = "Dynamic"
  service_plan_size = "Y1"
}
