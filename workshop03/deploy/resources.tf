locals {
    cs_domain = "${var.CF_subdomain}.${var.CF_domain}"
}
data digitalocean_ssh_key chuk {
    # resource name on digitalocean
    name = "chuk"
}

data digitalocean_image code-server {
    name = "code-server-${var.code_server_version}"
}

data cloudflare_zone dns-zone {
    name = var.CF_zone
}

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
    content = ""
    file_permission = "0644"
}

resource digitalocean_droplet code-server {
    name = "code-server-${var.code_server_version}"
    image = data.digitalocean_image.code-server.id
    region = var.droplet_region
    size = var.droplet_size
    ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file(var.private_key)
    }

    provisioner remote-exec {
        inline = [
            "sed -i 's/__DOMAIN__/${local.cs_domain}/' /etc/nginx/sites-available/code-server.conf",
            "sed -i 's/__PASSWORD__/${var.code_server_password}/' /lib/systemd/system/code-server.service",
            "systemctl daemon-reload",
            "systemctl restart nginx",
            "systemctl restart code-server"
        ]
    }
}

resource cloudflare_record codeserver-domain {
    name = var.CF_subdomain
    zone_id = data.cloudflare_zone.dns-zone.id
    type = "A"
    value = digitalocean_droplet.code-server.ipv4_address
}

output code_server_ip {
    value = digitalocean_droplet.code-server.ipv4_address
}