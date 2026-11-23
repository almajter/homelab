# apps

One folder, one Argo CD app. `config.yaml` sets the namespace and, for Helm
apps, the chart. Helm values go in `values.yaml`; apps without a chart use
`kustomization.yaml`. Sync is automatic (prune, self-heal). Removing a folder
leaves the app's resources running; delete them first. `ignoreDifferences` in
`config.yaml` is passed to the Application as is.

Secrets are created by hand with `kubectl create secret` before the app that
needs them syncs; none are in git.

- **alters-si**: my website. Chart and image come from
  [almajter/alters.si](https://github.com/almajter/alters.si), published to
  the self-hosted GitLab. Deploy = bump `version` in `config.yaml`.
- **argocd**: Helm 10.18.0, Argo CD managing itself. UI at
  `argocd.alters.si`; TLS ends at the reverse proxy, so `server.insecure`.
- **cnpg**: Helm 0.29.2, the CloudNativePG operator. Its CRDs are too big
  for client-side apply, so every app syncs with server-side apply.
- **finance-db**: one PostgreSQL 18 instance (CloudNativePG) for the finance
  apps, 5Gi on local-path. Roles and databases `firefly` and `ghostfolio` are
  declared in the `Cluster` and `Database` resources; passwords come from
  basic-auth Secrets.
- **firefly**: Helm 1.10.2, Firefly III (budgeting) at `firefly.alters.si`,
  daily cron job. The chart generates `APP_KEY` with `lookup`, which Argo CD
  can't run, so the real key comes from the `firefly` Secret (last in
  `envFrom`) and the chart's own key Secret is ignored.
- **firefly-importer**: Helm 1.6.1, Firefly III Data Importer at
  `firefly-importer.alters.si`. Authenticates with a Personal Access Token
  created in Firefly (Options → Profile → OAuth). It has no login of its own.
- **ghostfolio**: Ghostfolio (investments) at `ghostfolio.alters.si`, plus
  Redis without persistence as its cache. No official chart, so plain
  manifests.
- **monitoring**: Helm kube-prometheus-stack 93.4.1 (Prometheus, Alertmanager,
  Grafana at `grafana.alters.si`). Prometheus picks up monitors from every
  namespace (Traefik, finance-db), keeps 15 days on local-path. Alerts go by
  email through Brevo; the SMTP key and the recipient come from the
  `alertmanager-smtp` Secret (the recipient as a template, since `to` can't
  be read from a file). Etcd, scheduler, controller-manager and kube-proxy
  aren't scraped: kubeadm binds their metrics to localhost. Grafana has no
  volume; its dashboards come from grafana.com via values.
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
- **zalog-alters-si**: bouldering guide at `zalog.alters.si`. Chart and image
  come from [almajter/zalog.alters.si](https://github.com/almajter/zalog.alters.si),
  published to the self-hosted GitLab. Deploy = bump `version` in `config.yaml`.
