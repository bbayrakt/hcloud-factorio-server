# Deploy a Factorio server to Hetzner Cloud

## Variables
Adjust the given `/vars/factorio.yml` as needed.

| Variable | Description | Example |
| -------- | ----------- | ------- |
| `server_type` | Server type. The playbook only supports x86, as ARM support for Factorio server is experimental. List of server types: https://docs.hetzner.com/cloud/servers/overview/ | "cx32" |
| `datacenter` | Datacenter to deploy in. A list of available locations: https://docs.hetzner.com/cloud/general/locations/ | "fsn1-dc14" |
| `image` | VM image to use. The playbook is written with "docker-ce" in mind only at the moment. | "docker-ce" |
| `pub_ssh_key` | Path to your SSH public key to upload to the VM. | "~/.ssh/id_rsa.pub" |

## Prerequisites
- Ansible
- Terraform
- Hetzner Cloud account & API key

## Usage
```
export TF_VAR_hcloud_api_token=<your_hcloud_api_key>
ansible-playbook factorio_init.yml
```
