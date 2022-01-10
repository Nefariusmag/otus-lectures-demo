provider "yandex" {
  service_account_key_file = "../../key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "0.61.0"
}

resource "random_id" "new_id" {
  byte_length = 4
}
resource "random_password" "new_password" {
  length = 16
}
resource "random_integer" "new_int" {
  min = 1
  max = 255
}

locals {
  names = values(yandex_compute_instance.vm-app)[*].name
  ips   = values(yandex_compute_instance.vm-app)[*].network_interface.0.nat_ip_address
}

resource "local_file" "generate_inventory" {
  content = templatefile("hosts.tpl", {
    names = local.names,
    addrs = local.ips,
    user  = var.user
  })
  filename = "ansible/hosts"

  provisioner "local-exec" {
    command = "chmod a-x ansible/hosts"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "mv ansible/hosts ansible/hosts.backup"
    on_failure = continue
  }
}

resource "yandex_compute_instance" "vm-app" {
  for_each = toset(var.instances)
  name     = each.key

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

}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    # command = "sleep 50 && cd ansible && ansible-playbook play.yml"
    command = <<-EOT
      sleep 60 &&
      cd ansible &&
      ansible-playbook play.yml
    EOT
  }

  triggers = {
    addrs = join(",", local.ips),
  }

  depends_on = [local_file.generate_inventory]
}
