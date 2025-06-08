output public_ips{
    value = {
        cluspar_ip = mgc_virtual_machine_instances.cluspar.network_interfaces[0].ipv4
        monitoring_ip = mgc_virtual_machine_instances.monitoring.network_interfaces[0].ipv4
    }
}