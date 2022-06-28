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

variable "count_app" {
  default = 1
}

variable "names_db" {
  type = map(string)
  default = {
    dev2 = 2
  }
}
variable "names_front" {
  type = list(string)
  default = [
    "reddit-front-1",
    "reddit-front-2"
  ]
}
