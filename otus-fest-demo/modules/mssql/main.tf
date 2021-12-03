resource "azurerm_sql_server" "sql_server" {
  name                         = "${var.sql_name}"
  resource_group_name          = "${var.group}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sqluser}"
  administrator_login_password = "${var.sqlpassword}"
}

# DErokhin - dinamic
resource "azurerm_sql_firewall_rule" "firewall_rule_allow_for_developer" {
  depends_on = ["azurerm_sql_server.sql_server"]
  name                = "AllowConnectErokhin"
  resource_group_name = "${var.group}"
  server_name         = "${azurerm_sql_server.sql_server.name}"
  start_ip_address    = "109.252.65.144"
  end_ip_address      = "109.252.65.144"
}

resource "null_resource" "allow_access_from_azure_service" {
  depends_on = ["azurerm_sql_server.sql_server", "azurerm_sql_firewall_rule.firewall_rule_allow_for_developer"]

  provisioner "local-exec" {
    command = "az sql server firewall-rule create -g ${azurerm_sql_server.sql_server.resource_group_name} -s ${azurerm_sql_server.sql_server.name} -n myrule --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0"
  }
}
