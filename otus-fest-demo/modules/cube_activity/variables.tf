variable group {
  description = "group for work"
}

variable "location" {
  default = "westeurope"
}

variable "storage_connection_string" {}

variable "sqlserver_host" {
  description = "host of SQL server"
}

variable "sqlserver_database" {
  default = "cube_activity"
}

variable "sqlserver_user" {
  default = "bi-user"
}

variable "sqlserver_password" {
  description = "password of sql user"
}

variable "list_service_user" {
  default = "['', 'svc-cloud-etl-bi@cloud.infra.im', 'SYSTEM']"
}

variable "name_azure_func" {
  default = "imc-dev-666-mwe-globus-azure-funcion-cube-monitor"
}

variable "eventhub_connection" {}

variable "service_plan_tier" {
  default = "Dynamic"
}
variable "service_plan_size" {
  default = "Y1"
}