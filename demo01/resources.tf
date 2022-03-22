data digitalocean_ssh_key chuk {
    # resource name on digitalocean
    name = "chuk"
}

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
        //external = 8080
    }
}

output dov-names {
    value = docker_container.dov-bear-container[*].name
}

output external-ports {
    //value = docker_container.dov-bear-container[*].ports[*].external
    value = join(",", [ for p in docker_container.dov-bear-container[*].ports[*]: element(p, 0).external ])
}

output chuk_fingerprint {
    value = data.digitalocean_ssh_key.chuk.fingerprint
}