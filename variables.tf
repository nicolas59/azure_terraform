#Id de la resource groupe existante
variable "rg_demo_vnet" {
    default = "demo-vnet"
}

variable "subnet_app" {
    default = "/subscriptions/5124d2fd-9621-4e95-8944-e02f352e3607/resourceGroups/demo-vnet/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet-app"
}

variable "region" {
    default = "North Europe"
}


variable "app" {
  type = "map"
  default = {
    user = "nrousseau"
    sshcert = "Certificat"
    name = "nginx"
  }
  description = "Public ssh key to connect to the vm"
}
