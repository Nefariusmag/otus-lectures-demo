terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "../../key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "vm-demo" {
  name                      = "app"
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-demo.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_vpc_network" "network-demo" {}

resource "yandex_vpc_subnet" "subnet-demo" {
  zone           = var.zone
  network_id     = "${yandex_vpc_network.network-demo.id}"
  v4_cidr_blocks = [local.ips]
}

locals {
  ips = "10.131.0.0/24"
}
