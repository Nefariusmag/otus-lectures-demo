terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  token     = "token"
  cloud_id  = "b1ggtafb1eitul7eh533"
  folder_id = "b1goh6g9nk6btg9cf4b5"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-app-1" {
  name = "app-1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd807ed79a4kkqfvd1mb"
    }
  }

  network_interface {
    subnet_id = "e9bs05qo6i8u3dn5kfi0"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-elk" {
  name = "elk-server"

  resources {
    cores  = 4
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd807ed79a4kkqfvd1mb"
    }
  }

  network_interface {
    subnet_id = "e9bs05qo6i8u3dn5kfi0"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true
  }
}