resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.region
  tags = {
    Environment = "Development"
    project     = "PythonMicroservice"
  }
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-${var.aks}"
  default_node_pool {
    name       = "agentpool"
    node_count = var.node_count
    vm_size    = var.vm_type
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
  }
  tags = azurerm_resource_group.rg.tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  depends_on = [
    azurerm_container_registry.acr,
    azurerm_kubernetes_cluster.aks
  ]

}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfsa${random_string.unique.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = merge(
    azurerm_resource_group.rg.tags,
    {
      purpose = "terraform-state-storage"
    }
  )
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
