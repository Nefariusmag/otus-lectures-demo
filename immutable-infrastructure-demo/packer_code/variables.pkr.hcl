variable "environment" {
  default = "build image"
}

variable "client_id" {
  description = "Client ID of Azure account id"
}

variable "client_secret" {
  description = "Client secret of Azure account id"
}

variable "subscription_id" {
  description = "Subscription ID in Azure"
}

variable "tenant_id" {
  description = "Tenant ID in Azure"
}

variable "resource_group" {
  default = "immutable_infrastructure"
}
