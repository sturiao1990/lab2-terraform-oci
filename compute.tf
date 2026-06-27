# ─── Instâncias ───────────────────────────────────────────────────────────────
resource "oci_core_instance" "vm" {
  for_each = var.vms

  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  display_name        = each.value.display_name

  shape = local.vm_shapes[each.key].shape
  shape_config {
    ocpus         = local.vm_shapes[each.key].ocpus
    memory_in_gbs = local.vm_shapes[each.key].memory_in_gbs
  }

  source_details {
  source_type             = "image"
  source_id               = data.oci_core_images.oracle_linux.images[0].id
  boot_volume_size_in_gbs = "50"
}

  create_vnic_details {
    subnet_id        = local.vm_subnets[each.key]
    display_name     = each.value.hostname
    hostname_label   = each.value.hostname
    private_ip       = each.value.private_ip
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  freeform_tags = {
    environment = "labpipeline"
    managed_by  = "terraform"
  }
}

# ─── Disco extra 1 ────────────────────────────────────────────────────────────
resource "oci_core_volume" "extra_disk" {
  for_each = local.vms_with_extra_disk

  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  display_name        = "${each.value.display_name}-disk1"
  size_in_gbs         = each.value.extra_disk
}

resource "oci_core_volume_attachment" "extra_disk" {
  for_each = local.vms_with_extra_disk

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.vm[each.key].id
  volume_id       = oci_core_volume.extra_disk[each.key].id
  display_name    = "${each.value.display_name}-disk1-attach"
}

# ─── Disco extra 2 ────────────────────────────────────────────────────────────
resource "oci_core_volume" "extra_disk2" {
  for_each = local.vms_with_extra_disk2

  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  display_name        = "${each.value.display_name}-disk2"
  size_in_gbs         = each.value.extra_disk2
}

resource "oci_core_volume_attachment" "extra_disk2" {
  for_each = local.vms_with_extra_disk2

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.vm[each.key].id
  volume_id       = oci_core_volume.extra_disk2[each.key].id
  display_name    = "${each.value.display_name}-disk2-attach"
}

# ─── Disco extra 3 ────────────────────────────────────────────────────────────
resource "oci_core_volume" "extra_disk3" {
  for_each = local.vms_with_extra_disk3

  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  display_name        = "${each.value.display_name}-disk3"
  size_in_gbs         = each.value.extra_disk3
}

resource "oci_core_volume_attachment" "extra_disk3" {
  for_each = local.vms_with_extra_disk3

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.vm[each.key].id
  volume_id       = oci_core_volume.extra_disk3[each.key].id
  display_name    = "${each.value.display_name}-disk3-attach"
}