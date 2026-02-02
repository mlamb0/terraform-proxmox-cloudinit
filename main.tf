locals {
  # Convert the map to a list for easier lookup by ID, or just iterate the map
  # This creates a map where keys are the IDs (0, 1, etc) and values are the formatted strings
  ipconfigs = {
    for k, v in var.network : v.id => 
      v.gw != null ? "ip=${v.ip},gw=${v.gw}" : "ip=${v.ip}"
  }
}

resource "proxmox_vm_qemu" "main" {
  name = var.name
  vmid = var.vmid
  target_node = var.target_node
  clone = var.clone
  agent = var.qemu_guest_agent_enabled ? 1 : 0

  os_type = "cloud-init"
  ciuser = var.ciuser
  sshkeys = var.sshkeys[0]

  cpu {
    cores = var.cpu_cores
    sockets = var.cpu_sockets
    type = var.cpu_type
  }

  memory = var.memory
  
  disk {
    type = "cloudinit"
    slot = "ide2"
    storage = var.cloudinit_disk_storage
  }

  scsihw = "virtio-scsi-single"
  
  dynamic "disk" {
    for_each = var.disk
    content {
      slot = disk.key
      type = disk.value.type
      storage = disk.value.storage_location_name
      size = disk.value.size
      cache = disk.value.cache
      replicate = disk.value.replicate
      emulatessd = disk.value.emulatessd
   } 
  }

  bootdisk = var.bootdisk

  dynamic "network" {
    for_each = var.network
    content {
      id = network.value.id
      bridge = network.value.bridge
      model = network.value.model
      tag = network.value.tag
    }
  }

  ipconfig0 = lookup(local.ipconfigs, 0, null)
  ipconfig1 = lookup(local.ipconfigs, 1, null)
  ipconfig2 = lookup(local.ipconfigs, 2, null)
  ipconfig3 = lookup(local.ipconfigs, 3, null)

  serial {
    id = 0
    type = "socket"
  }  
}