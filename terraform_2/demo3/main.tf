provider "yandex" {
  service_account_key_file = "../../key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "0.61.0"
}

resource "yandex_vpc_network" "network-demo3" {}

resource "yandex_vpc_subnet" "subnet-demo3" {
  zone           = var.zone
  network_id     = yandex_vpc_network.network-demo3.id
  v4_cidr_blocks = ["10.131.0.0/24"]
}

module "app" {
  source    = "./app"
  subnet_id = yandex_vpc_subnet.subnet-demo3.id
  image_id  = var.image_id
  count_app = var.count_app
}
module "db" {
  source    = "./db"
  subnet_id = yandex_vpc_subnet.subnet-demo3.id
  image_id  = var.image_id
  names_db  = var.names_db
}
