


resource "azurerm_network_interface" "nics" {
  for_each = merge([
    for k, v in var.environment : {
      for i in range(v.count) : "${k}-${i}" => {
        environment_key = k
        index = i
      }
    }
  ]...)

  name                = "${each.value.environment_key}-nic-${each.value.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_ids[each.value.environment_key]}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

output "nic_ids" {
  value = {
      for key, nic in azurerm_network_interface.nics : key => nic.id
  }
  description = "NIC List"
} 