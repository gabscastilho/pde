output cluspar_ips{
    value = {
        private_ip = mgc_virtual_machine_instances.cluspar.network_interfaces[0].local_ipv4
        public_ip = mgc_virtual_machine_instances.cluspar.network_interfaces[0].ipv4
    }
}

output monitoring_ips{
    value = {
        private_ip = mgc_virtual_machine_instances.monitoring.network_interfaces[0].local_ipv4
        public_ip = mgc_virtual_machine_instances.monitoring.network_interfaces[0].ipv4
    }
}

locals {
    cluspar = {
        private_ip = mgc_virtual_machine_instances.cluspar.network_interfaces[0].local_ipv4
        public_ip = mgc_virtual_machine_instances.cluspar.network_interfaces[0].ipv4
    }
    monitoring = {
        private_ip = mgc_virtual_machine_instances.monitoring.network_interfaces[0].local_ipv4
        public_ip = mgc_virtual_machine_instances.monitoring.network_interfaces[0].ipv4
    }
}
resource local_file inventory_template {
    filename = "../ansible/inventory.yaml"
    content = templatefile("${path.module}/inventory.yaml.tmpl", {
        cluspar = local.cluspar
        monitoring = local.monitoring
    })
}