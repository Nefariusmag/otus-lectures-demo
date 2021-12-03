variable "sql_name" {
  default = ""
}

variable group {
  description = "group for work"
}

variable location {
  default = "westeurope"
}

variable "sqldatabase_cube_activity" {
  default = "cube_activity"
}

variable sqluser {
  default = "bi-user"
  description = "Default user of SQL"
}

variable sqlpassword {
  description = "Password of vm user"
}

variable "sql_size_edition" {
  default = "Basic"
}
variable "sql_size_version" {
  default = "Basic"
}