// Variable declaration
variable DO_token {
    type = string
    sensitive = true
}

variable droplet_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable droplet_size {
    type = string
    default = "s-1vpcu-1gb"
}

variable droplet_region {
    type = string
    default = "sgp1"
}

variable code_server_version {
    type = string
    default = "4.2.0"
}

source digitalocean code_server {
    api_token = var.DO_token
    region = var.droplet_region
    image = var.droplet_image
    size = var.droplet_size
    ssh_username = "root"
    snapshot_name = "code-server-${var.code_server_version}"
}

build {
    sources = [ "source.digitalocean.code_server" ]

    provisioner ansible {
        playbook_file = "playbook.yaml"
        extra_arguments = [
            "-e", "code_server_version=${var.code_server_version}"
        ]
    }
}