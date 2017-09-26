#Id de la resource groupe existante
variable "rg_demo_vnet" {
    default = "demo-vnet"
}

variable "subnet_app" {
    default = "demo-vnet"
}

#resource "azurerm_resource_group" "test" {
#  name     = "acctestrg"
#  location = "West US 2"
#}

#resource "azurerm_virtual_network" "vn" {
#  name                = "acctvn"
#  address_space       = ["10.0.0.0/16"]
#  location            = "West US 2"
#  resource_group_name = "${azurerm_resource_group.test.name}"
#}

#resource "azurerm_subnet" "test" {
#  name                 = "acctsub"
#  resource_group_name  = "${azurerm_resource_group.test.name}"
#  virtual_network_name = "${azurerm_virtual_network.test.name}"
#  address_prefix       = "10.0.2.0/24"
#}

resource "azurerm_network_interface" "nexus" {
  name                = "nexus_int"
  location            = "North Europe"
  resource_group_name = "${var.rg_demo_vnet}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.subnet_app}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "nexus" {
  name                 = "datadisk_existing"
  location             = "North Europe"
  resource_group_name  = "${var.rg_demo_vnet}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

resource "azurerm_virtual_machine" "nexus" {
  name                  = "acctvm"
  location              = "North Europe"
  resource_group_name   = "${var.rg_demo_vnet}"
  network_interface_ids = ["${azurerm_network_interface.nexus.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.nexus.name}"
    managed_disk_id = "${azurerm_managed_disk.nexus.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.nexus.disk_size_gb}"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}