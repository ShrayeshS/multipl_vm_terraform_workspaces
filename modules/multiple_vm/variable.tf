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

variable "location" {
  type        = string
  description = "The location where the VM are deployed"
  default     = "East US 2"
}

variable "nic_ids" {
    description = "Map of NIC ID"
    type = map(any)
    default = {}
}