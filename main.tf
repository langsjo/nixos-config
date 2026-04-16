terraform {
  backend "s3" {
    bucket         = "tofu-state-gorilla"
    key            = "homelab/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tofu-state-lock"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Static DNS records for homelab services (pointing to Tailscale IPs)
locals {
  dns_records = {
    "*.intra" = "100.64.0.2"
  }
}

resource "cloudflare_record" "homelab" {
  for_each = local.dns_records

  zone_id = var.cloudflare_zone_id
  name    = each.key
  content = each.value
  type    = "A"
  ttl     = 1
  proxied = false
}
