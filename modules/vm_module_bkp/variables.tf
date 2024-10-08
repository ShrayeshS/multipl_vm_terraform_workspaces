variable "prefix" {
  default = "testmachine"
}

variable "location" {
  type        = string
  description = "The target Azure region for resources to be deployed"
  default     = "East US 2"
}

variable "Virtual_Network_Name" {
  type        = string
  description = "Name of the virtual network"
  default     = "testnetwork"
}

variable "Virtual_network_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Name of the virtual network"
  default     = "internal"
}

variable "subnet_address_prefixes" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}


variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "example1"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "my-windowsvm"
}

variable "gallery_image_definition_id" {
  description = "ID of the Shared Image Gallery image definition to use for VM creation"
  default     = "/subscriptions/9c926ecd-5e53-4cf7-87be-8a58f0639a00/resourceGroups/ab-ca-vm-gallery-prd/providers/Microsoft.Compute/galleries/ab_ca_vm_goldenimages_prd_gal/images/windows2022/versions/2.0.30"
}

variable "azurecomputegallery" {
  type        = string
  description = "The target Azure compute gallery for resources to be deployed"
  default     = "TestAzureComputeGallary"
}

variable "env" {
  description = "environment to deploy to"
  type        = string
  default     = "test"
}

variable "admin_username" {
  description = "Admin User Name"
  type        = string
  default     = "devsecops"
}

variable "admin_password" {
  description = "Admin Password"
  type        = string
  default     = "MphasisPune#1234"
}

variable "network_interface_ids" {
  description = "Network Interface ID"
  type   = list(string)
  default     = ["MphasisPune#1234"]
}