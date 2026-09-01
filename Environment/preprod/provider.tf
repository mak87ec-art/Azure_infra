terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "5.0.1"
    }
  }
  backend "azurerm" {
    resource_group_name = "mak"
    storage_account_name = "storageforstate007"
    container_name = "state-container"
    key = "new.statefile"
  }
}
provider "azurerm" {
  features {}
}
