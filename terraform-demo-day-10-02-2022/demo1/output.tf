output "interlat_ip" {
  value = yandex_compute_instance.vm-demo.network_interface.0.ip_address
}
output "external_ip" {
  value = yandex_compute_instance.vm-demo.network_interface.0.nat_ip_address
}
