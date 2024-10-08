variable "environment" {
    description = "Map of every environment and their parameters"
    type = map(any)
    default = {}
}

variable "resource_group_name" {
  description = "resource group"
  type        = string
  default     = "test"
}

variable "virtual_network_name" {
  type        = string
  description = "The VNet name"
  default     = "vnet"
}

variable "location" {
  type        = string
  description = "The location where the VM are deployed"
  default     = "East US 2"
}

variable "ssh_allow" {
  type    = string
  description = "Bastion Subnet CIDR"
  default     = "10.1.4.0/24"
}