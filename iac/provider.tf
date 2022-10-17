terraform {
  required_version = ">=0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  client_id       = var.spn_client_id
  client_secret   = var.spn_client_secret
  subscription_id = var.subscription_id

  features {}
}
