resource "azurerm_eventhub_namespace" "bi_event_hub" {
  name                = "${var.name_evenhub}"
  location            = "${var.location}"
  resource_group_name = "${var.group}"
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "cube_engine_logs_event_hub" {
  name                = "insights-logs-engine"
  namespace_name      = "${azurerm_eventhub_namespace.bi_event_hub.name}"
  resource_group_name = "${var.group}"
  partition_count     = 4
  message_retention   = 7
}

resource "azurerm_eventhub_authorization_rule" "eventhub_authorization_rule_send" {
  name                = "GetEventsForHub"
  namespace_name      = "${azurerm_eventhub_namespace.bi_event_hub.name}"
  eventhub_name       = "${azurerm_eventhub.cube_engine_logs_event_hub.name}"
  resource_group_name = "${var.group}"
  listen              = true
  send                = true
  manage              = false
}

