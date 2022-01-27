provider "yandex" {
  service_account_key_file = "../../key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "0.61.0"
}

resource "yandex_compute_instance" "monitoring-server" {
  name = "monitoring-service"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
      size     = 50
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

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -so ~/unattended-installation.sh https://packages.wazuh.com/resources/4.2/open-distro/unattended-installation/unattended-installation.sh",
      "sudo chmod +x ~/unattended-installation.sh",
      "sudo ~/unattended-installation.sh",
    ]
  }
}

resource "yandex_compute_instance" "monitoring-client" {
  count      = 1
  name       = "monitoring-client-${count.index}"
  depends_on = [yandex_compute_instance.monitoring-server]

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
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

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -",
      "echo 'deb https://packages.wazuh.com/4.x/apt/ stable main' | sudo tee -a /etc/apt/sources.list.d/wazuh.list",
      "sudo apt-get update -y",
      "sudo WAZUH_MANAGER=${yandex_compute_instance.monitoring-server.network_interface.0.nat_ip_address} apt-get install wazuh-agent -y",
      "sudo systemctl daemon-reload",
      "sudo systemctl start wazuh-agent",
      "sudo systemctl enable wazuh-agent"
    ]
  }
}

resource "yandex_compute_instance" "monitoring-client-centos" {
  count      = 1
  name       = "monitoring-client-centos-${count.index}"
  depends_on = [yandex_compute_instance.monitoring-server]

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80le4b8gt2u33lvubr"
    }
  }

  network_interface {
    subnet_id = "e9bs05qo6i8u3dn5kfi0"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true
  }

  # connection {
  #   type        = "ssh"
  #   host        = self.network_interface.0.nat_ip_address
  #   user        = "centos"
  #   agent       = false
  #   private_key = file("~/.ssh/id_rsa")
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #
  #   ]
  # }
}
