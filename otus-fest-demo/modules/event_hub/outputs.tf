output "event_hub_connection" {
  value = "${azurerm_eventhub_authorization_rule.eventhub_authorization_rule_send.primary_connection_string}"
}