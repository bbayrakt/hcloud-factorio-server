terraform {
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
            version = "~> 1.45"
        }
    }
}

provider "hcloud" {
    token = var.hcloud_api_token
}

resource "hcloud_server" "factorio" {
    name = "Factorio"
    datacenter = var.datacenter
    image = var.image
    server_type = var.server_type
    ssh_keys = [ hcloud_ssh_key.factorio.id ]
    firewall_ids = [ hcloud_firewall.factorio.id ]

    public_net {
      ipv4_enabled = true
      ipv6_enabled = true

      ipv4 = hcloud_primary_ip.factorio_ipv4.id
    }
}

resource "hcloud_primary_ip" "factorio_ipv4" {
  name          = "factorio_ipv4"
  datacenter    = "fsn1-dc14"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "type" : "ipv4"
    "server" : "factorio"
  }
}

resource "hcloud_primary_ip" "factorio_ipv6" {
  name          = "factorio_ipv6"
  datacenter    = "fsn1-dc14"
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "type" : "ipv6"
    "server" : "factorio"
  }
}

resource "hcloud_ssh_key" "factorio" {
    name = "Factorio"
    public_key = file(var.pub_ssh_key)
}

resource "hcloud_firewall" "factorio" {
    name = "factorio-firewall"

    # ICMP
    rule {
      direction = "in"
      protocol = "icmp"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    }

    # Factorio server port
    rule {
        direction = "in"
        protocol = "udp"
        port = "34197"
        source_ips = [
            "0.0.0.0/0",
            "::/0"
        ]
    }

    # SSH
    rule {
        direction = "in"
        protocol = "tcp"
        port = "22"
        source_ips = [
            "0.0.0.0/0",
            "::/0"
        ]
    }
}

output "ipv4_address" {
    value = hcloud_primary_ip.factorio_ipv4.ip_address
}
