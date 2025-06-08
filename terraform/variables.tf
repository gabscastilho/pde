# api-key
variable api_key{
    type = string
    description = "api key, dã"
    sensitive = true
}

# ssh key
variable ssh_key {
    type = string
    description = "Path to the SSH key"
    default = "/home/augusto/.ssh/id_ed25519.pub"
}

# Machine images
variable cluspar_machine_image {
    type = string
    description = "cluspar machines image"
    default     = "cloud-ubuntu-22.04 LTS"
}

variable monitoring_machine_image {
    type = string
    description = "monitoring machines image"
    default     = "cloud-ubuntu-22.04 LTS"
}

# Machine types
variable cluspar_machine_type {
    type = string
    description = "cluspar machines type (flavor)"
    default = "BV2-4-20"
}

variable monitoring_machine_type {
    type = string
    description = "monitoring machines type (flavor)"
    default = "BV1-1-20"
}