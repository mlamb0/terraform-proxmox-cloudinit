variable "name" {
  description = "The name of the virtual machine"
  type = string
}

variable "vmid" {
  description = "The virtual machine ID in Proxmox"
  type = number
}

variable "target_node" {
  description = "The name of the Proxmox node where the VM will be placed"
  type = string
}

variable "clone" {
  description = "The name of the template in Proxmox to clone from"
  type = string
}

variable "cpu_cores" {
  description = "The number of vCPUs for the VM"
  type = number
  default = 1
}

variable "cpu_sockets" {
  description = "The number of CPU sockets for the VM"
  type = number
  default = 1
}

variable "cpu_type" {
  description = "The type of CPU of the VM"
  type = string
  default = "host"
}

variable "memory" {
  description = "The amount of RAM assigned to the VM (in MB)"
  type = number
  default = 1024
}

variable "cloudinit_disk_storage" {
  description = "The name of the storage device in Proxmox where the cloudinit disk should exist"
  type = string
}

variable "disk" {
  description = "Disks to be assigned to the VM, note: the name of the individual disk maps are used for the 'slot' variable in the disk block"
  type = map(object({
    type = optional(string)
    storage_location_name = string
    size = number
    cache = optional(string)
    replicate = optional(bool)
    emulatessd = optional(bool)
  }))
}

variable "bootdisk" {
  description = "The name of disk in which the VM should boot from, this would be the name of the disk map defined above"
  type = string
}

variable "network" {
  description = "Map of a network device to be attached to the VM"
  type = map(object({
    id = number
    bridge = string
    model = string
    tag = optional(number)
  }))
}

variable "qemu_guest_agent_enabled" {
  description = "Whether or not the QEMU guest agent is enabled on the VM"
  type = bool
  default = false
}

variable "ciuser" {
  description = "The username of the Cloud Init user"
  type = string
  default = null
}

variable "cipassword" {
  description = "The password for the Cloud Init user"
  type = string
  default = null
}

variable "nameserver" {
  description = "The DNS servers for the VM"
  type = list(string)
  default = [ "1.1.1.1", "8.8.8.8" ]
}

variable "sshkeys" {
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
  type = list(string)
  default = null
}
