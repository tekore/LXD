resource "lxd_cached_image" "ubuntu2404" {
  source_remote = "ubuntu"
  source_image  = "24.04"
  type          = "virtual-machine"
}

resource "lxd_instance" "kubernetes-node" {
  count       = 3
  name        = "Kubernetes-${count.index}"
  description = "Kubernetes node"
  image       = lxd_cached_image.ubuntu2404.fingerprint
  type        = "virtual-machine"
  limits = {
    cpu    = 4
    memory = "8000MB"
  }
  config = {
    "boot.autostart"           = true
    "cloud-init.user-data"     = <<-EOT
      #cloud-config
      package_update: true
      packages:
        - ansible
      runcmd:
        - ansible-pull -U https://github.com/tekore/Ansible.git -i localhost, playbooks/configureKubernetes.yml
    EOT
  }
  ephemeral = false
  depends_on = [lxd_cached_image.ubuntu2404]
}