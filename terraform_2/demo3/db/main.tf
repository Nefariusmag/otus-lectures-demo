resource "yandex_compute_instance" "vm-db" {

  for_each = var.names_db
  name     = "reddit-db-${each.key}"

  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      size     = 30
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "files/test.txt"
    destination = "/tmp/db.txt"
  }

}
