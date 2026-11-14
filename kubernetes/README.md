# kubernetes

## Bootstrap (once)

```sh
# on k8s-cp-01
sudo kubeadm init --control-plane-endpoint k8s-cp-01.home.alters.si --pod-network-cidr 10.244.0.0/16

# on your machine
ssh debian@10.0.10.20 sudo cat /etc/kubernetes/admin.conf > ~/.kube/homelab
chmod 600 ~/.kube/homelab
export KUBECONFIG=~/.kube/homelab

# Cilium
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.20.4 -n kube-system -f kubernetes/apps/cilium/values.yaml
cilium status --wait

# workers: on k8s-cp-01, then run the printed command with sudo on each worker
sudo kubeadm token create --print-join-command

kubectl get nodes

# Argo CD
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd --version 10.18.0 -n argocd --create-namespace
kubectl apply -f kubernetes/bootstrap/applicationset.yaml
```

Change the admin password (Secret `argocd-initial-admin-secret` in `argocd`),
then delete the Secret.

Argo CD then syncs every app on its own. For `cilium` that only adds
tracking-id annotations, since the values are the same. Then delete Helm's
record so Argo CD is the only owner:
`kubectl -n kube-system delete secret sh.helm.release.v1.cilium.v1`. Never
run `helm upgrade` or `helm uninstall` on it.

Cilium runs with `ipam.mode: kubernetes`, so pods get `10.244.x.x` instead of
the default `10.0.0.0/8`, which overlaps the LAN.
