terraform {
    required_version = ">1.1.0"    
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.18.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.2.2"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "3.11.0"
        }
        acme = {
            source  = "vancluever/acme"
            version = "2.8.0"
        }
    }
}

provider "digitalocean" {
    token = var.DO_token
}
provider "cloudflare" {
    email = var.CF_email
    api_token = var.CF_api_token
}
provider "acme" {
    server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
provider "local" { }