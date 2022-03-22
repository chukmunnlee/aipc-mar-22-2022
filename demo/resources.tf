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
    name = "dov"
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
        //external = 8080
    }
}

output chuk_fingerprint {
    value = data.digitalocean_ssh_key.chuk.fingerprint
}