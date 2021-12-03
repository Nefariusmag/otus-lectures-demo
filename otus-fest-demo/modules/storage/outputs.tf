output "storage_url" {
  value = "${azurerm_storage_account.storage.primary_blob_endpoint}"
}

output "storage_primary_connection_string" {
  value = "${azurerm_storage_account.storage.primary_connection_string}"
}