provider "yandex" {
  version                  = "0.35"
  service_account_key_file = "../key.json"

  # token     = "your token"
  cloud_id  = "b1grun15v8ep7ebgqulb"
  folder_id = "b1gp7fkqqgoffgaef9an"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-demo1" {
  name = "reddit-app"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ss1glhqmibnugh9v8"
    }
  }

  network_interface {
    subnet_id = "e9bljer22a0prq6ta3dl"
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
