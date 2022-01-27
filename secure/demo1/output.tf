output "wazuh_server_ip" {
  value = "https://${yandex_compute_instance.monitoring-server.network_interface.0.nat_ip_address}"
}
output "wazuh_client_ip" {
  value = "${yandex_compute_instance.monitoring-client.*.network_interface.0.nat_ip_address}"
}
output "wazuh_clien_centos_ip" {
  value = "${yandex_compute_instance.monitoring-client-centos.*.network_interface.0.nat_ip_address}"
}
