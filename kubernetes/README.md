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
helm install argocd argo/argo-cd --version 10.18.0 -n argocd --create-namespace -f kubernetes/apps/argocd/values.yaml
kubectl apply -f kubernetes/bootstrap/applicationset.yaml
```

Change the admin password (Secret `argocd-initial-admin-secret` in `argocd`),
then delete the Secret.

Argo CD then syncs every app on its own, including `cilium` and itself
(`argocd`). Both were installed with the same values, so that only adds
tracking-id annotations. Then delete Helm's records so Argo CD is the only
owner:

```sh
kubectl -n kube-system delete secret sh.helm.release.v1.cilium.v1
kubectl -n argocd delete secret sh.helm.release.v1.argocd.v1
```

Don't run `helm upgrade` or `helm uninstall` on either afterwards. The one
exception: if a bad push breaks Argo CD, `helm upgrade --install` with
working values brings it back.

Cilium runs with `ipam.mode: kubernetes`, so pods get `10.244.x.x` instead of
the default `10.0.0.0/8`, which overlaps the LAN.
