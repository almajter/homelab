# ansible

Gets the VMs ready for kubeadm: IP forwarding, containerd,
kubeadm/kubelet/kubectl (held, so `apt upgrade` skips them) and the QEMU
guest agent.

```sh
# from the repo root
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook -i ansible/inventory.ini ansible/node-prep.yml
```
