locals {
  nodes = {
    k8s-cp-01 = { vm_id = 120, ip = "10.0.10.20", memory = 4096, disk = 30 }
    k8s-w-01  = { vm_id = 121, ip = "10.0.10.21", memory = 8192, disk = 50 }
    k8s-w-02  = { vm_id = 122, ip = "10.0.10.22", memory = 8192, disk = 50 }
  }
}

resource "proxmox_virtual_environment_vm" "node" {
  for_each = local.nodes

  name            = each.key
  vm_id           = each.value.vm_id
  node_name       = "pve"
  stop_on_destroy = true

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.debian13.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "10.0.10.1"
      }
    }

    dns {
      servers = ["10.0.10.17"]
    }

    user_account {
      username = "debian"
      keys     = [trimspace(file("~/.ssh/id_rsa.pub"))]
    }
  }
}

resource "proxmox_virtual_environment_vm" "gpu" {
  name            = "k8s-gpu-01"
  vm_id           = 123
  node_name       = "pve"
  stop_on_destroy = true
  machine         = "q35"
  bios            = "ovmf"

  agent {
    enabled = true
  }

  cpu {
    cores = 6
    type  = "host"
  }

  memory {
    dedicated = 32768
  }

  efi_disk {
    datastore_id      = "local-lvm"
    type              = "4m"
    pre_enrolled_keys = false
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.ubuntu2404.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 100
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio1"
    backup       = false
    iothread     = true
    discard      = "on"
    size         = 300
  }

  hostpci {
    device  = "hostpci0"
    mapping = "rtx3090"
    pcie    = true
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.0.10.23/24"
        gateway = "10.0.10.1"
      }
    }

    dns {
      servers = ["10.0.10.17"]
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(file("~/.ssh/id_rsa.pub"))]
    }
  }
}
