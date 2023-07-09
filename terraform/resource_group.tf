
# in order to share resource group between multiple modules, we create it separately and define as data source here
data "azurerm_resource_group" "main" {
  name     = "bunnyshell-rg"
}

# # this is the original resource group definition
# resource "azurerm_resource_group" "main" {
#   name     = "bunnyshell-rg"
#   location = var.location
#   tags     = local.tags
# }
