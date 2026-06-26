output "vms_private_ips" {
  description = "IPs privados de cada VM criada"
  value = {
    for k, v in oci_core_instance.vm :
    k => v.private_ip
  }
}

output "vcn_id" {
  value = oci_core_vcn.main.id
}