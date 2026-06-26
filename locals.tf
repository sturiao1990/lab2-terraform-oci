locals {

  # Bind subnet_key → OCID da subnet criada no network.tf
  subnet_ids = {
    "app"      = oci_core_subnet.app.id
    "database" = oci_core_subnet.database.id
  }

  # Resolve shape completo a partir da chave
  vm_shapes = {
    for k, v in var.vms :
    k => var.shape_catalog[v.shape_key]
  }

  # Resolve image OCID a partir da chave
  vm_images = {
    for k, v in var.vms :
    k => var.image_catalog[v.image_key]
  }

  # Resolve subnet OCID a partir da chave
  vm_subnets = {
    for k, v in var.vms :
    k => local.subnet_ids[v.subnet_key]
  }

  # Filtra apenas VMs que precisam de disco extra (campo > 0)
  vms_with_extra_disk  = { for k, v in var.vms : k => v if v.extra_disk > 0 }
  vms_with_extra_disk2 = { for k, v in var.vms : k => v if v.extra_disk2 > 0 }
  vms_with_extra_disk3 = { for k, v in var.vms : k => v if v.extra_disk3 > 0 }
}