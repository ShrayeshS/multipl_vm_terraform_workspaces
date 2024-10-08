resource "azurerm_subnet" "internal_sn" {
  for_each = var.environment

  name                 = each.value["name"]
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefixes     = each.value["address_prefixes"]
} 

resource "azurerm_network_security_group" "internal_nsg" {
  for_each = var.environment
  name                = each.key
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "InboundSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.ssh_allow}"
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
    source_address_prefix      = each.value["address_prefixes"][0]
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
  for_each = var.environment
  subnet_id                 = azurerm_subnet.internal_sn[each.key].id
  network_security_group_id = azurerm_network_security_group.internal_nsg[each.key].id
}

output "internal_subnet_ids_map" {
  value = {
      for id in keys(var.environment) : id => azurerm_subnet.internal_sn[id].id
  }
  description = "Subnet List"
}

