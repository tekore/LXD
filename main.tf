terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}

provider "lxd" {
  generate_client_certificates = false
  accept_remote_certificate    = true
  config_dir                   = "/home/runner/.terraform.d/lxd"

  remote {
    name    = "lxd-host"
    address = "https://${var.lxd-host.address}:${var.lxd-host.port}"
    default = true
  }
}