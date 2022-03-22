data digitalocean_ssh_key chuk {
    # resource name on digitalocean
    name = "chuk"
}

// Step 1 - Create 3 containers
// Image
resource docker_image dov-bear {
    name = "chukmunnlee/dov-bear:v2"
    keep_locally = true
}

// container
resource docker_container dov-bear-container {
    count = 3
    name = "dov-${count.index}"
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
    }
    env = [
        "INSTANCE_NAME=dov-${count.index}"
    ]
}

// Step 2 - Generate nginx.conf 
resource local_file nginx_conf {
    filename = "nginx.conf"
    content = templatefile("nginx.conf.tftpl", {
        docker_host_ip = var.docker_host_ip 
        container_ports = [ for p in docker_container.dov-bear-container[*].ports[*]: element(p, 0).external ]
    })
    file_permission = "0644"
} 

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
    content = ""
    file_permission = "0644"
}

// Step 3 Provision a droplet
resource digitalocean_droplet ngnix {
    name = "nginx"
    image = var.droplet_image
    region = var.droplet_region
    size = var.droplet_size
    ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.nginx.ipv4_address
        private_key = file(var.private_key)
    }

    // Install nginx package
    provisioner remote-exec {
        inline = [
            "apt update",
            "apt install -y nginx"
        ]
    }

    // Copy config file over
    provisioner file {
        source = "./nginx.conf"
        destination = "/etc/nginx"
    }

    // Restart nginx cause we have updated the configuration
    provisioner remote-exec {
        inline = [
            "systemctl restart nginx"
        ]
    }
    
}

output external-ports {
    //value = docker_container.dov-bear-container[*].ports[*].external
    value = join(",", [ for p in docker_container.dov-bear-container[*].ports[*]: element(p, 0).external ])
}

output nginx_ip {
    value = digitalocean_droplet.nginx.ipv4_address
}