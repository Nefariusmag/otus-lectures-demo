resource "yandex_compute_instance" "vm-app" {
  count                     = var.count_app
  name                      = "reddit-app-${count.index}"
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 4
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

  provisioner "local-exec" {
    command = "echo nihao > files/test.txt"
  }

  provisioner "file" {
    source      = "files/test.txt"
    destination = "/tmp/app.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "ip ad",
      "cat /tmp/app.txt",
    ]
  }

}
