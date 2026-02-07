resource "lxd_cached_image" "xenial" {
  source_remote = "ubuntu"
  source_image  = "xenial/amd64"
}

resource "lxd_instance" "instance1" {
  count = 30
  name  = "instance-${count.index}"
  image = lxd_cached_image.xenial.fingerprint
  type = "virtual-machine"
  config = {
    "boot.autostart" = true
  }
  limits = {
    cpu = 2
  }
  ephemeral = false
  depends_on = [ lxd_cached_image.xenial ]
}