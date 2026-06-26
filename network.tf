# ─── VCN ──────────────────────────────────────────────────────────────────────
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "vcn-labpipeline"
  dns_label      = "labpipeline"
}

# ─── Internet Gateway ─────────────────────────────────────────────────────────
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "igw-labpipeline"
  enabled        = true
}

# ─── Route Table ──────────────────────────────────────────────────────────────
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "rt-labpipeline-public"

  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# ─── Security List ────────────────────────────────────────────────────────────
resource "oci_core_security_list" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "sl-labpipeline"

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options { min = 22 max = 22 }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# ─── Subnets ──────────────────────────────────────────────────────────────────
resource "oci_core_subnet" "app" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.main.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "subnet-app"
  dns_label         = "app"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.main.id]
}

resource "oci_core_subnet" "database" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.main.id
  cidr_block        = "10.0.2.0/24"
  display_name      = "subnet-database"
  dns_label         = "database"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.main.id]
}