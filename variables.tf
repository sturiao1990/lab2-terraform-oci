# ─── Credenciais OCI ─────────────────────────────────────────────────────────
variable "tenancy_ocid"     { type = string }
variable "user_ocid"        { type = string }
variable "fingerprint"      { type = string }
variable "private_key_path" { type = string }

variable "region" {
  type    = string
  default = "sa-saopaulo-1"
}

variable "compartment_ocid" { type = string }

# ─── Chave SSH para acesso às VMs ─────────────────────────────────────────────
variable "ssh_public_key" { type = string }

# ─── Catálogo de shapes ───────────────────────────────────────────────────────
variable "shape_catalog" {
  type = map(object({
    shape         = string
    ocpus         = number
    memory_in_gbs = number
  }))
  default = {
    "1ocpu_8gb" = {
      shape         = "VM.Standard.A1.Flex"
      ocpus         = 1
      memory_in_gbs = 8
    }
    "2ocpu_16gb" = {
      shape         = "VM.Standard.A1.Flex"
      ocpus         = 2
      memory_in_gbs = 16
    }
    "4ocpu_32gb" = {
      shape         = "VM.Standard.A1.Flex"
      ocpus         = 4
      memory_in_gbs = 32
    }
    "8ocpu_64gb" = {
      shape         = "VM.Standard.A1.Flex"
      ocpus         = 8
      memory_in_gbs = 64
    }
  }
}

# ─── Catálogo de imagens ──────────────────────────────────────────────────────
variable "image_catalog" {
  type = map(string)
  default = {
    "ol9"     = "ocid1.image.oc1.sa-saopaulo-1."
    "ol8"     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaYYYYYYYYYYYYYYYYYY"
    "win2025" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaZZZZZZZZZZZZZZZZZZ"
  }
}

# ─── Catálogo de subnets ──────────────────────────────────────────────────────
variable "subnet_catalog" {
  type = map(string)
  default = {
    "app"      = ""
    "database" = ""
    "mgmt"     = ""
  }
}

# ─── Definição das VMs ────────────────────────────────────────────────────────
variable "vms" {
  type = map(object({
    display_name = string
    hostname     = string
    private_ip   = string
    shape_key    = string
    image_key    = string
    subnet_key   = string
    boot_volume  = number
    extra_disk   = optional(number, 0)
    extra_disk2  = optional(number, 0)
    extra_disk3  = optional(number, 0)
  }))
  default = {
    "labpipeline-vm01" = {
      display_name = "labpipeline-vm01"
      hostname     = "labpipeline-vm01"
      private_ip   = "10.0.1.10"
      shape_key    = "1ocpu_8gb"
      image_key    = "ol9"
      subnet_key   = "app"
      boot_volume  = 50
      extra_disk   = 0
      extra_disk2  = 0
      extra_disk3  = 0
    }
  }
}