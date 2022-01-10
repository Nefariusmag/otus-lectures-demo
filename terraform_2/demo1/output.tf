output "external_ip_app" {
  value = yandex_compute_instance.vm-app.*.network_interface.0.nat_ip_address
}
output "external_ip_db" {
  value = [ for v in yandex_compute_instance.vm-db : v.network_interface.0.nat_ip_address ]
}
output "external_ip_front" {
  value = yandex_compute_instance.vm-front.*.network_interface.0.nat_ip_address
}
