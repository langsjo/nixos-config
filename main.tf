terraform {
  backend "s3" {
    bucket     = "tofu-state"
    key        = "homelab/terraform.tfstate"
    region     = "auto"
    endpoints  = { s3 = "https://${var.r2_account_id}.r2.cloudflarestorage.com" }
    access_key = var.r2_access_key_id
    secret_key = var.r2_secret_access_key

    # R2 has no DynamoDB; lock with a .tflock object (conditional writes).
    use_lockfile = true

    # R2 is not AWS: skip the AWS-only checks and request features.
    use_path_style              = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "r2_account_id" {
  type = string
}

variable "r2_access_key_id" {
  type = string
}

variable "r2_secret_access_key" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "gorilla_zone_id" {
  type      = string
  sensitive = true
}

variable "langsjo_zone_id" {
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
    "t3.intra" = "100.64.0.1"
  }
}

resource "cloudflare_record" "langsjo" {
  for_each = local.dns_records

  zone_id = var.langsjo_zone_id
  name    = each.key
  content = each.value
  type    = "A"
  ttl     = 1
  proxied = false
}
