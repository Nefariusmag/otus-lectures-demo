output "external_ip_app" {
  value = module.app.external_ip
}
output "external_ip_db" {
  value = module.db.external_ip
}
