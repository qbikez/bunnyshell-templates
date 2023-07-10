resource "azurerm_storage_account" "main" {
  name = "bns${var.instance_suffix}"

  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
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

resource "azurerm_storage_table" "orders" {
  name                 = "orders"
  storage_account_name = azurerm_storage_account.main.name
}