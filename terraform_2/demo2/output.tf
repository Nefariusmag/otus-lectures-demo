output "external_ips" {
  value = [for v in yandex_compute_instance.vm-app : v.network_interface.0.nat_ip_address]
}

output "new_id" {
  value = random_id.new_id.id
}

output "new_password" {
  value     = random_password.new_password
  sensitive = true
}

output "new_int" {
  value = random_integer.new_int.id
}
