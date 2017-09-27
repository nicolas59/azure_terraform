
resource "azurerm_public_ip" "nginx" {
  name                         = "nginx_public_ip"
  location                     = "${var.region}"
  resource_group_name          = "${var.rg_demo_vnet}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "staging"
  }
}

resource "azurerm_network_security_group" "sg-nginx" {
  name                = "sg-nginx"
  location            = "${var.region}"
  resource_group_name = "${var.rg_demo_vnet}"

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "staging"
  }
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

resource "azurerm_network_interface" "nginx" {
  name                = "nginx_int"
  location            = "${var.region}"
  resource_group_name = "${var.rg_demo_vnet}"
  network_security_group_id  = "${azurerm_network_security_group.sg-nginx.id}"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.subnet_app}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.nginx.id}"
  }
}

resource "azurerm_managed_disk" "nginx" {
  name                 = "datadisk_existing"
  location             = "${var.region}"
  resource_group_name  = "${var.rg_demo_vnet}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

resource "azurerm_virtual_machine" "nginx" {
  name                  = "${var.app["name"]}"
  location              = "${var.region}"
  resource_group_name   = "${var.rg_demo_vnet}"
  network_interface_ids = ["${azurerm_network_interface.nginx.id}"]
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
    name              = "osdisk_${var.app["name"]}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  #storage_data_disk {
  #  name              = "datadisk_new"
  #  managed_disk_type = "Standard_LRS"
  #  create_option     = "Empty"
  #  lun               = 0
  #  disk_size_gb      = "1023"
  #}

  storage_data_disk {
    name            = "${azurerm_managed_disk.nginx.name}"
    managed_disk_id = "${azurerm_managed_disk.nginx.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.nginx.disk_size_gb}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.app["user"]}/.ssh/authorized_keys"
      key_data = "${var.app["sshcert"]}"
    }
  }

  os_profile {
    computer_name  = "nginx"
    admin_username = "${var.app["user"]}"
    admin_password = "Password1234!"
    #custom_data = "${file("init-vm.sh")}"
  }

  tags {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_extension" "nginx" {
  name                 = "init_nging"
  location             = "${var.region}"
  resource_group_name  = "${var.rg_demo_vnet}"
  virtual_machine_name = "${azurerm_virtual_machine.nginx.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<EOF
    {
        "commandToExecute": "${file("init-vm.sh")}"
    }
EOF

  tags {
    environment = "staging"
  }
}