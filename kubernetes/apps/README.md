# apps

One folder, one Argo CD app. `config.yaml` sets the namespace and, for Helm
apps, the chart. Helm values go in `values.yaml`; apps without a chart use
`kustomization.yaml`. Sync is automatic (prune, self-heal). Removing a folder
leaves the app's resources running; delete them first.

- **cilium**: Helm 1.20.4. Hubble (Cilium's flow observability) certificates come from a CronJob in the
  cluster; otherwise Argo CD sees new ones on every sync.
- **local-path**: upstream v0.0.37, made the default StorageClass. Data lives
  in `/opt/local-path-provisioner/` on each node.
- **metallb**: Helm 0.16.2, L2 mode (ARP). Gives `LoadBalancer` Services an IP.
- **metallb-config**: pool `10.0.10.30-10.0.10.33` and its L2Advertisement.
- **traefik**: Helm 42.4.0, default IngressClass, Service on `10.0.10.30`.
  `externalTrafficPolicy: Local` and trusting the reverse proxy
  (`10.0.10.14`) keep the client IP in `X-Forwarded-For`.
- **whoami**: test app at `whoami.alters.si`, echoes the request.
