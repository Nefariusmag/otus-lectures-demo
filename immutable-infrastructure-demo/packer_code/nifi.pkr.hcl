source "azure-arm" "subscription_1" {
  azure_tags = {
    environment = "${var.environment}"
    project     = "bi"
  }

  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  image_offer                       = "CentOS"
  image_publisher                   = "OpenLogic"
  image_sku                         = "7.5"
  location                          = "West Europe"
  managed_image_name                = "nifi-image-{{timestamp}}"
  managed_image_resource_group_name = "${var.resource_group}"
  os_type                           = "Linux"
  subscription_id                   = "${var.subscription_id}"
  tenant_id                         = "${var.tenant_id}"
  vm_size                           = "Standard_DS3_v2"
}

build {
  sources = ["source.azure-arm.subscription_1"]

  provisioner "ansible" {
    extra_arguments = ["-e remote_user=azureuser"]
    playbook_file   = "nifi.yml"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }
}
