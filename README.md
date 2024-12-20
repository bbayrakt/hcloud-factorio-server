# Deploy a Factorio server to Hetzner Cloud
Deploy a cloud server for hosting a Factorio server, and destroy the server while backing up the 
save file to be able to redeploy the server only and only when you're ready to play again!

Hetzner calls their cloud hosting "truly thrifty", and we're truly putting that to the test here.
The server that I am using costs around 0.0131€ per hour, so you'll be paying 1.34€ per 100 hours of 
hosting.

Me and old friends have been excited about the impending Factorio expansion, and I thought, what better
way to prepare for a game about automation by automating the deployment of a game about automation?

## Prerequisites
- Ansible
- Hetzner Cloud account & API key
- CloudFlare DNS (Optional)

## Variables
Create `/vars/factorio.yml` using the given example file and adjust as needed.

| Variable | Description | Example |
| -------- | ----------- | ------- |
| `hcloud_api_token` | Put this value in your environment variables as `HCLOUD_TOKEN` | `export HCLOUD_TOKEN=xxxxxx` |
| `hcloud_server_type` | Server type. The playbook only supports x86, as ARM support for Factorio server is experimental. List of server types: https://docs.hetzner.com/cloud/servers/overview/ | "cx32" |
| `hcloud_datacenter` | Datacenter to deploy in. A list of available locations: https://docs.hetzner.com/cloud/general/locations/ | "fsn1" |
| `hcloud_image` | VM image to use. The playbook is written with "docker-ce" in mind only at the moment. | "docker-ce" |
| `hcloud_pub_ssh_key` | Path to your SSH public key to upload to the VM. | "~/.ssh/id_rsa.pub" |
| `cf_api_token` | Your CloudFlare API Token. | <cf_token> |
| `cf_zone` | Your CloudFlare DNS Zone. | "example.com" |
| `cf_record` | Your subdomain for the DNS Zone. | "factorio" |
| `factorio_servername` | Your Factorio server name, optional. | "HCloud Factorio Server" |
| `factorio_serverdescription` | Your Factorio server description, optional. | "Thrifty Hetzner Cloud Factorio Server" |
| `factorio_username` | Your Factorio.com username. | <factorio_username> |
| `factorio_token` | Your Factorio.com token. | <factorio_token> |
| `factorio_whitelist` | List of players to whitelist, optional. | ["list","of","players"] |
| `factorio_banlist` | List of players to banlist, optional. | ["list","of","players"] |
| `factorio_adminlist` | List of players to adminlist, optional. | ["list","of","players"] |
| `factorio_serverpassword` | Password protection for your server. | <factorio_server_password> |


## Usage
For creating a server, run the following:
```
export HCLOUD_TOKEN=<your_hcloud_api_key>
ansible-playbook factorio_init.yml
```
This will start your server - if you have a preexisting save, just place it in the root of this project's folder and rename it to `ansible_managed_save.zip`. The server will then start with that save file. If you have an existing Ansible managed server snapshot on Hetzner, that server will be started instead.

For saving the game and snapshotting the server, run the following:
```
export HCLOUD_TOKEN=<your_hcloud_api_key>
ansible-playbook factorio_snapshot.yml
```
This will save the game locally (just in case!) and snapshot your server, and delete the server. Deletion is necessary to not pay money on server costs - simply turning off the server still costs the full amount on Hetzner Cloud. Having a snapshot costs a marginal amount of money, but you'll want to delete that if you don't plan on playing for a longer period of time or you are finished with playing.

For deleting the server and all related resources (and saving the game before doing so), run:
```
export TF_VAR_hcloud_api_token=<your_hcloud_api_key>
ansible-playbook factorio_destroy.yml
```
Which will save the latest savegame to the root of the project folder.
