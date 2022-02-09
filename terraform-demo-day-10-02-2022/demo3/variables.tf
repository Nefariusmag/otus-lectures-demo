variable "cloud_id" {
  description = "cloud_id from yandex"
}

variable "folder_id" {
  description = "Folder from yandex console"
}

variable "zone" {
  default     = "ru-central1-a"
  description = "Zone"
  type        = string
}

variable "image_id" {
  description = "image id that we use"
}

variable "count_app" {
  default = 2
}

variable "names_db" {
  type = map(string)
  default = {
    dev1 = 2,
    dev2 = 2,
  }
}
