data digitalocean_ssh_key chuk {
    # resource name on digitalocean
    name = "chuk"
}

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
    content = ""
    file_permission = "0644"
}

resource local_file inventory_yaml {
    filename = "inventory.yaml"
    content = templatefile("inventory.tpl", {
        code_server = digitalocean_droplet.code-server.name
        code_server_ip = digitalocean_droplet.code-server.ipv4_address
        private_key = var.private_key
        code_server_password = var.code_server_password
        code_server_domain = "code-${digitalocean_droplet.code-server.ipv4_address}.nip.io"
    })
    file_permission = "0644"
}

resource digitalocean_droplet code-server {
    name = "code-server"
    image = var.droplet_image
    region = var.droplet_region
    size = var.droplet_size
    ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file(var.private_key)
    }

}

output code_server_ip {
    value = digitalocean_droplet.code-server.ipv4_address
}