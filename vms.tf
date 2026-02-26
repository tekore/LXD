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
    memory = "8192MB"
  }
  device {
    name = "root"
    type = "disk"
    properties = {
      pool = "storage-pool"
      path = "/"
      size = "25GB"
    }
  }
  device {
    name = "eth0"
    type = "nic"
    properties = {
      # [Description] lxbr0 is the default bridge created by LXD
      network     = "lxdbr0"
      "ipv4.address" = "192.168.1.10${count.index}"
    }
  }
  config = {
    "boot.autostart"           = true
    "cloud-init.network-config" = <<-EOT
      version: 2
      ethernets:
        eth0:
          match:
            name: "en*"
          set-name: eth0
          addresses: [192.168.1.10${count.index}/24]
          nameservers:
            addresses: [1.1.1.1, 8.8.8.8]
          routes:
            - to: default
              via: 192.168.1.1
            - to: 192.168.1.1/32
              via: 0.0.0.0
              scope: link
    EOT
    "cloud-init.user-data" = <<-EOT
      #cloud-config
      package_update: true
      packages:
        - ansible
      runcmd:
        - ansible-pull -U https://github.com/tekore/Ansible.git -i localhost, playbooks/provisionNewServer.yml
        - ansible-pull -U https://github.com/tekore/Ansible.git -i localhost, playbooks/configureKubernetes.yml
    EOT
  }
  ephemeral = false
  depends_on = [lxd_cached_image.ubuntu2404]
}