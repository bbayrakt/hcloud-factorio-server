variable "hcloud_api_token" {
  sensitive = true
  type      = string
}

variable "server_type" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "image" {
  type = string
}

variable "pub_ssh_key" {
  type = string
}