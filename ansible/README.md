# ansible

Gets the VMs ready for kubeadm: IP forwarding, containerd,
kubeadm/kubelet/kubectl (held, so `apt upgrade` skips them) and the QEMU
guest agent. Works on Debian and Ubuntu (the GPU node).

containerd loads `/etc/containerd/conf.d/*.toml`, where the NVIDIA toolkit
puts its runtime. On the GPU node the toolkit also rewrites `config.toml`,
so every run there shows `changed` and restarts containerd.

```sh
# from the repo root
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook -i ansible/inventory.ini ansible/node-prep.yml
```
