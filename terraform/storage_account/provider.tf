provider "azurerm" {
  features {}
}

terraform {
#   backend "azurerm" {
#   }
   required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.57.0"
    }
  }
}


data "azurerm_client_config" "current" {}