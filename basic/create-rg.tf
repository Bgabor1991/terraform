provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Learning-terraform" {
  name     = "Learning-terraform"
  location = "UK South"
}