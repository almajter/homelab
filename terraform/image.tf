resource "proxmox_download_file" "debian13" {
  content_type       = "import"
  datastore_id       = "local"
  node_name          = "pve"
  url                = "https://cloud.debian.org/images/cloud/trixie/20261103-2651/debian-13-genericcloud-amd64-20261103-2651.qcow2"
  checksum           = "d25999de0770d4cde1be72c299ba3ad94eac7ea8fd4d18f8cc86c69df69337e2e8a91d64465a9bfd8f2a78c566fcbcb0842eacc91c09efdef72d719d9f13b535"
  checksum_algorithm = "sha512"
}

resource "proxmox_download_file" "ubuntu2404" {
  content_type       = "import"
  datastore_id       = "local"
  node_name          = "pve"
  url                = "https://cloud-images.ubuntu.com/noble/20261017/noble-server-cloudimg-amd64.img"
  file_name          = "noble-server-cloudimg-amd64-20261017.qcow2"
  checksum           = "04e8f2461a16a44e78a370284471f29616cdd9baf1893df25807b71f985b6c94"
  checksum_algorithm = "sha256"
}
