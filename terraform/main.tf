terraform {
    required_providers {
        mgc = {
            source = "magalucloud/mgc"
            version = "0.33.0"
        }
    }    
}

provider "mgc" {
    region = "br-ne1"
    api_key = var.api_key
}

# Virtual Machines
resource "mgc_ssh_keys" "cluspar_ssh_key" {
    key = file(var.ssh_key)
    name = "cluspar_ssh_key"
}

## VMs
resource "mgc_virtual_machine_instances" "cluspar" {
    name = "cluspar"
    machine_type = var.cluspar_machine_type
    image = var.cluspar_machine_image
    ssh_key_name = mgc_ssh_keys.cluspar_ssh_key.name
}

resource "mgc_virtual_machine_instances" "monitoring" {
    name = "monitoring"
    machine_type = var.monitoring_machine_type
    image = var.monitoring_machine_image
    ssh_key_name = mgc_ssh_keys.cluspar_ssh_key.name
}

# Network
## VPC
resource "mgc_network_vpcs" "cluspar"{
    name = "cluspar"
    description = "VPC for deploying cluspar"
}

## Public IPs
resource "mgc_network_public_ips" "cluspar"{
    description = "Public IP for cluspar"
    vpc_id = mgc_network_vpcs.cluspar.id
}

resource "mgc_network_public_ips_attach" "cluspar"{
    public_ip_id = mgc_network_public_ips.cluspar.id
    interface_id = mgc_virtual_machine_instances.cluspar.network_interfaces[0].id   # Using first interface as public
}

resource "mgc_network_public_ips" "monitoring"{
    description = "Public IP for monitoring vm"
    vpc_id = mgc_network_vpcs.cluspar.id
}

resource "mgc_network_public_ips_attach" "monitoring"{
    public_ip_id = mgc_network_public_ips.monitoring.id
    interface_id = mgc_virtual_machine_instances.monitoring.network_interfaces[0].id   # Using first interface as public
}

## Security groups
resource "mgc_network_security_groups" "cluspar" {
    name = "cluspar"
    description = "Security group for cluspar public access"
    disable_default_rules = false
}

resource "mgc_network_security_groups_rules" "allow_neo4j" {
    description = "Allow access to neo4j"
    direction = "ingress"
    ethertype = "IPv4"
    port_range_max = 7474
    port_range_min = 7474
    protocol = "tcp"
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = mgc_network_security_groups.cluspar.id
}

resource "mgc_network_security_groups_rules" "allow_neo4j_2" {
    description = "Allow access to neo4j"
    direction = "ingress"
    ethertype = "IPv4"
    port_range_max = 7687
    port_range_min = 7687
    protocol = "tcp"
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = mgc_network_security_groups.cluspar.id
}

resource "mgc_network_security_groups_attach" "cluspar"{
    security_group_id = mgc_network_security_groups.cluspar.id
    interface_id = mgc_virtual_machine_instances.cluspar.network_interfaces[0].id
}

resource "mgc_network_security_groups" "monitoring" {
    name = "monitoring"
    description = "Security group for monitoring public access"
    disable_default_rules = false
}

resource "mgc_network_security_groups_rules" "allow_prometheus_server" {
    description = "Allow access to Prometheus"
    direction = "ingress"
    ethertype = "IPv4"
    port_range_max = 9090
    port_range_min = 9090
    protocol = "tcp"
    remote_ip_prefix = "0.0.0.0/0"
    security_group_id = mgc_network_security_groups.monitoring.id
}

resource "mgc_network_security_groups_attach" "monitoring"{
    security_group_id = mgc_network_security_groups.monitoring.id
    interface_id = mgc_virtual_machine_instances.monitoring.network_interfaces[0].id
}