variable "location" {
    type = string
    description = "The target Azure region for resources to be deployed"
    default = "East US 2"
}

variable "vnet" {
    type = string
    description = "Virtual Network"
    default = "cen-vnet-vm"
}

variable "vnet_rg" {
    type = string
    description = "Virtual Network Resource Group"
    default = "DXO_Integration_RG"
}

variable "virtual_network_address_space" {
  description = "The target Vnet address Space"
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "bastion_network_address_space" {
  description = "The bastion subnet address space"
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "bastion_vm_size" {
  description = "The bastion vm size"
  type    = string
  default = "Standard_DS1_v2"
}

variable "environment" {
  description = "Environment"
  type    = string
  default = "qa"
}

variable "vm_count" {
    type = number
    description = "Count of instances"
    default = 2
}

variable "address_prefixes" {
    type = list(string)
    description = "Address Prefix"
    default = ["10.2.3.0/24"]
}

variable "vm_size" {
    type = string
    description = "Virtual Machine Size"
    default = "Standard_DS1_v2"
}