locals {
  tags = {
    environment = "dev"
    owner       = "bunnyshell"
    project     = "bunnyshell"
    terraform   = true
  }
}

resource "azurerm_resource_group" "main" {
  name     = "bunnyshell-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "main" {
  name = var.storage_account_name

  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  account_kind              = "Storage"
  enable_https_traffic_only = false
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  tags                      = local.tags
}



resource "azurerm_storage_container" "oc-private" {
  name                  = "oc-private"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "oc-public" {
  name                  = "oc-public"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}