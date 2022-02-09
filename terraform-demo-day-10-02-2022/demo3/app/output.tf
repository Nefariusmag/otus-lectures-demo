output "external_ip" {
  value = yandex_compute_instance.vm-app.*.network_interface.0.nat_ip_address
}
