provider "yandex" {
  version   = "0.35"
  service_account_key_file = "../key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "vm-demo2" {
  name = "reddit-app"
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-demo2.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type = "ssh"
    host = yandex_compute_instance.vm-demo2.network_interface.0.nat_ip_address
    user = "ubuntu"
    agent = false
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source = "files/test.txt"
    destination = "/tmp/test.txt"
  }

}

resource "yandex_vpc_network" "network-demo2" {}

resource "yandex_vpc_subnet" "subnet-demo2" {
  zone       = var.zone
  network_id = "${yandex_vpc_network.network-demo2.id}"
  v4_cidr_blocks = [local.ips]
}

locals {
  ips = "10.131.0.0/24"
}
