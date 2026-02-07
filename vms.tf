resource "lxd_instance" "instance1" {
  count = 10
  name  = "instance-${count.index}"
  image = "ubuntu-daily:22.04"
  type = virtual-machine
  config = {
    "boot.autostart" = true
  }

  limits = {
    cpu = 1
  }
}