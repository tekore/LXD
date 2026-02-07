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
  config_dir                   = "~/.terraform.d/lxd"

  lxd_remote {
    name    = "lxd-host"
    scheme  = "https"
    address = "${var.lxd-host.address}:${var.lxd-host.port}"
    default = true
  }
}