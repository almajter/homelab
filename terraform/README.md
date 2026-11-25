# terraform

Creates the three VMs from the Debian 13 cloud image, plus `k8s-gpu-01`
from Ubuntu 24.04 with the RTX 3090 passed through.

Needs:

- a Proxmox API token with the [provider's privileges](https://registry.terraform.io/providers/bpg/proxmox/latest/docs),
  plus `Datastore.AllocateTemplate` and `Sys.Modify` for the image download
- storage `local` with content type Import
- DNS records for the nodes under `home.alters.si` on `10.0.10.17`
- `~/.ssh/id_rsa.pub`, which becomes the `debian` / `ubuntu` user's key
- a PCI resource mapping `rtx3090` (Datacenter → Resource Mappings) and
  `Mapping.Use` for the token: a raw PCI id needs `root@pam`

```sh
cp .env.example .env   # then fill in the token
source .env
terraform init
terraform apply
```

- Changing `initialization` reboots all VMs and gives them new SSH host keys
  (`ssh-keygen -R <ip>`).
- Nodes use only `10.0.10.17` for DNS. With the router as a second server,
  pods sometimes couldn't resolve LAN names.
