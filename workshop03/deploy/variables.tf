variable DO_token {
    description = "Access token"
    type = string
    sensitive = true
}

variable private_key {
    type = string
    sensitive = true
}

variable CF_api_token {
    type = string
    sensitive = true
}

variable CF_zone {
    type = string
    default = "chuklee.com"
}

variable CF_email {
    type = string
    sensitive = true
}

variable droplet_size {
    type = string
    default = "s-1vcpu-2gb"
}

variable droplet_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable droplet_region {
    type = string
    default = "sgp1"
}

variable code_server_version {
    type = string
    default = "4.2.0"
}

variable CF_domain {
    type = string
}
variable CF_subdomain {
    type = string
    default = "codeserver"
}

variable code_server_password {
    type = string
    sensitive = true
}