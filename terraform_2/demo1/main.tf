provider "yandex" {
  service_account_key_file = "../../key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "0.61.0"
}

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
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-demo1.id
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

  depends_on = [
    yandex_compute_instance.vm-db
  ]

}

resource "yandex_compute_instance" "vm-db" {

  # for_each = { dev1 = 2, dev2 = 4 }
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
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-demo1.id
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


resource "yandex_compute_instance" "vm-front" {
  count                     = length(var.names_front) // 2 -> 1
  name                      = var.names_front[count.index]
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
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-demo1.id
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
    destination = "/tmp/front.txt"
  }

  depends_on = [
    yandex_compute_instance.vm-db,
    yandex_compute_instance.vm-app
  ]

}

resource "yandex_vpc_network" "network-demo1" {}

resource "yandex_vpc_subnet" "subnet-demo1" {
  zone           = var.zone
  network_id     = yandex_vpc_network.network-demo1.id
  v4_cidr_blocks = ["10.131.0.0/24"]
}
