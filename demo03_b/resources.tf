 data digitalocean_ssh_key chuk {
    # resource name on digitalocean
    name = "chuk"
}

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
    content = ""
    file_permission = "0644"
}

// Step 3 Provision a droplet
resource digitalocean_droplet nginx {
    name = "nginx"
    image = var.droplet_image
    region = var.droplet_region
    size = var.droplet_size
    ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]
}

output nginx_ip {
    value = digitalocean_droplet.nginx.ipv4_address
}