terraform {
  backend "azurerm" {
    resource_group_name  = "rg-pythonApp"
    storage_account_name = "tfsa0utuuru7"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
