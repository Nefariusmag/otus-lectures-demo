variable "subnet_id" {
  description = "subnet_id from yandex"
}

variable "image_id" {
  description = "image id that we use"
}

variable "names_db" {
  type = map(string)
  default = {
    dev1 = 1
  }
}
