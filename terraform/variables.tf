variable "region" {
  description = "Azure region where resources are created"
  type        = string
  default     = "eastus2"
}

variable "resource_group" {
  description = "resource group name"
  type        = string
  default     = "rg-pythonApp"
}

variable "acr" {
  description = "container registery name"
  type        = string
  default     = "acrpythonapp"
}

variable "aks" {
  description = "kubernates cluster name"
  type        = string
  default     = "aks-pythonApp"
}

variable "node_count" {
  description = "number of nodes in aks"
  type        = number
  default     = 1
}

variable "vm_type" {
  description = "machine type"
  type        = string
  default     = "Standard_B2ms"
}
