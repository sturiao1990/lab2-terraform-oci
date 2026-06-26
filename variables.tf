# ─── Credenciais OCI ─────────────────────────────────────────────────────────
variable "tenancy_ocid"     { type = string }
variable "user_ocid"        { type = string }
variable "fingerprint"      { type = string }
variable "private_key_path" { type = string }
variable "region"           { type = string default = "sa-saopaulo-1" }
variable "compartment_ocid" { type = string }

# ─── Chave SSH para acesso às VMs ─────────────────────────────────────────────
variable "ssh_public_key" { type = string }

# ─── Catálogo de shapes ───────────────────────────────────────────────────────
# Centralize aqui todos os shapes que você usa no ambiente.
# Ao criar uma VM, basta referenciar a chave (ex: "1ocpu_8gb").
variable "shape_catalog" {
  type = map(object({
    shape = string
    ocpus = number
    memory_in_gbs = number
  }))
  default = {
    "1ocpu_8gb" = {
      shape         = "VM.Standard.E4.Flex"
      ocpus         = 1
      memory_in_gbs = 8
    }
    "2ocpu_16gb" = {
      shape         = "VM.Standard.E4.Flex"
      ocpus         = 2
      memory_in_gbs = 16
    }
    "4ocpu_32gb" = {
      shape         = "VM.Standard.E4.Flex"
      ocpus         = 4
      memory_in_gbs = 32
    }
    "8ocpu_64gb" = {
      shape         = "VM.Standard.E4.Flex"
      ocpus         = 8
      memory_in_gbs = 64
    }
  }
}

# ─── Catálogo de imagens ──────────────────────────────────────────────────────
# Centralize os OCIDs das imagens por região.
# Ao criar uma VM, basta referenciar a chave (ex: "ol9").
variable "image_catalog" {
  type = map(string)
  default = {
    # Oracle Linux 9 - sa-saopaulo-1
    "ol9"     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaegchzhtlevyku5o6nqv2j2z3anw2fq2r5lasufys4ei2lw65rkva"
    # Oracle Linux 8 - sa-saopaulo-1
    "ol8"     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaYYYYYYYYYYYYYYYYYY"
    # Windows Server 2025
    "win2025" = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaZZZZZZZZZZZZZZZZZZ"
  }
}

# ─── Catálogo de subnets ──────────────────────────────────────────────────────
# Mapeie as chaves de subnet aos OCIDs reais ou use referências locais.
# Se a subnet for criada no network.tf, o locals.tf fará o bind.
variable "subnet_catalog" {
  type = map(string)
  default = {
    "app"      = "" # preenchido via locals.tf referenciando oci_core_subnet
    "database" = "" # preenchido via locals.tf referenciando oci_core_subnet   
  }
}

# ─── Definição das VMs ────────────────────────────────────────────────────────
# Este é o único lugar onde você cadastra novas VMs.
# Campos com optional e valor 0 significam "sem disco extra".
variable "vms" {
  type = map(object({
    display_name = string
    hostname     = string
    private_ip   = string
    shape_key    = string            # referencia shape_catalog
    image_key    = string            # referencia image_catalog
    subnet_key   = string            # referencia locals.subnet_ids
    boot_volume  = number            # tamanho em GB do boot volume
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
    # Exemplo de como adicionar uma segunda VM futuramente:
    # "brocisv020dbv" = {
    #   display_name = "brocisv020dbv"
    #   hostname     = "brocisv020dbv"
    #   private_ip   = "10.253.229.20"
    #   shape_key    = "8ocpu_64gb"
    #   image_key    = "win2025"
    #   subnet_key   = "database"
    #   boot_volume  = 100
    #   extra_disk   = 300
    #   extra_disk2  = 100
    #   extra_disk3  = 50
    # }
  }
}