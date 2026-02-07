//main.tf
variable "lxd-host" {
  type = object({
    address = string
    port = string
  })
  sensitive = true
}

variable "lxd-bucket" {
  type = object({
    endpoint = string
    port = string
    access_key = string
    secret_key = string
  })
  sensitive = true
}