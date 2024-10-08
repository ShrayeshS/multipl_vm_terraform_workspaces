resource "azurerm_subnet" "internal_subnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.vnet}"
  address_prefixes     = "${var.address_prefixes}"
} 

resource "azurerm_network_security_group" "internal_nsg" {
  name                = "${var.name}-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.internal_subnet.id
  network_security_group_id = azurerm_network_security_group.internal_nsg.id
}

