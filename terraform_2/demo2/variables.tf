variable "cloud_id" {
  description = "cloud_id from yandex"
}

variable "folder_id" {
  description = "Folder from yandex console"
}

variable "zone" {
  default     = "ru-central1-a"
  description = "Zone"
}

variable "image_id" {
  description = "image id that we use"
}

variable "instances" {
  type = list(string)
  default = [
    "app-1",
    "app-2",
    "lb"
  ]
}

variable "user" {
  type    = string
  default = "ubuntu"
}

variable "subnet_id" {
  default = "e9bs05qo6i8u3dn5kfi0"
}
