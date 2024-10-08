resource "azurerm_virtual_machine" "internal-vm" {
  for_each = merge([
    for k, v in var.environment : {
      for i in range(v.count) : "${k}-${i}" => {
        environment_key = k
        index = i
      }
    }
  ]...)

  name                  = "${each.value.environment_key}-vm-${each.value.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = [lookup(var.nic_ids, "${each.value.environment_key}-${each.value.index}", null)]
  vm_size               = var.environment["${each.value.environment_key}"]["vm_size"]
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
    name              = "myosdisk-${each.value.environment_key}-${each.value.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    
  }

  os_profile {
    computer_name  = "${each.value.environment_key}-vm-${each.value.index}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}