variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "spn_client_id" {
  type = string
}

variable "spn_client_secret" {
  type = string
}

variable "azure_location" {
  default = "westeurope"
  description = "Location of Azure resources."
}

variable "resource_group_name_prefix" {
    default = "rg"
    description = "Prefix of the resource group name"
}