resource "random_integer" "rand_int" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  location = var.azure_location
  name     = "rg-talentagileshop-${random_integer.rand_int.result}"
}

resource "azurerm_service_plan" "appserviceplan" {
  name = "tashop-webapp-asp-${random_integer.rand_int.result}"
  location = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  os_type = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "webapp" {
  name = "tashop-webapp-${random_integer.rand_int.result}"
  location = var.azure_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.appserviceplan.id
  https_only = true
  site_config {
    minimum_tls_version = "1.2"
    always_on = false
  }
}