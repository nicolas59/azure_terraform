output "ip" {
  value = "${azurerm_public_ip.nginx.ip_address}"
}