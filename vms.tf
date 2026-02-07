resource "lxd_cached_image" "ubuntu2404" {
  source_remote = "ubuntu"
  source_image  = "24.04"
  type          = "virtual-machine"
}

resource "lxd_instance" "instance1" {
  count = 3
  name  = "instance-${count.index}"
  image = lxd_cached_image.ubuntu2404.fingerprint
  type = "virtual-machine"
  config = {
    "boot.autostart" = true
  }
  limits = {
    cpu = 2
  }
  ephemeral = false
  depends_on = [ lxd_cached_image.ubuntu2404 ]
}