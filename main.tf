resource "azurerm_resource_group" "environments_rg" {
  name     = "terraform-rg-${var.environment}"
  location = var.location
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "cen-subnet-${var.environment}"
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet
  address_prefixes     = var.address_prefixes
}

resource "azurerm_network_security_group" "internal_nsg" {
  name                = "nsg-${var.environment}"
  location            = "${var.location}"
  resource_group_name = "${var.vnet_rg}"

  security_rule {
    name                       = "InboundSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.bastion_network_address_space[0]}"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "InboundSubnet"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.address_prefixes[0]
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAll"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "internal_nsg_a" {
  subnet_id                 = azurerm_subnet.example_subnet.id
  network_security_group_id = azurerm_network_security_group.internal_nsg.id
}

resource "azurerm_network_interface" "example_nic" {
  count = var.vm_count  

  name                = "cen-nic-${var.environment}-${count.index + 1}"  # Naming each NIC uniquely
  location            = var.location
  resource_group_name = azurerm_resource_group.environments_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_virtual_machine" "internal-vm" {
  count = var.vm_count

  name                  = "cen-${var.environment}-vm-${count.index + 1}"
  location              = "${var.location}"
  resource_group_name   = azurerm_resource_group.environments_rg.name
  network_interface_ids = [element(azurerm_network_interface.example_nic[*].id, count.index)]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = "true"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${var.environment}-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    
  }

  os_profile {
    computer_name  = "cen-${var.environment}-vm-${count.index + 1}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "subnet_id" {
  value = azurerm_subnet.example_subnet.id
}

output "nic_ids" {
  value = [for nic in azurerm_network_interface.example_nic : nic.id]
}

output "nic_ip_addresses" {
  value = [for nic in azurerm_network_interface.example_nic : nic.ip_configuration[0].private_ip_address]
}