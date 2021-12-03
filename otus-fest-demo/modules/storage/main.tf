resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_name}"
  resource_group_name      = "${var.group}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "app-service-backup"
  resource_group_name   = "${azurerm_storage_account.storage.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}
