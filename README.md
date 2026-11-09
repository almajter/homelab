# homelab

Kubernetes cluster on a single Proxmox host, built with kubeadm.

- `terraform/` - the VMs (bpg/proxmox provider)
- `ansible/` - node prep: containerd, kubeadm, kubelet
- `kubernetes/` - Argo CD bootstrap and the apps it deploys
