output "external_ip" {
  value = [ for v in yandex_compute_instance.vm-db : v.network_interface.0.nat_ip_address ]
}
