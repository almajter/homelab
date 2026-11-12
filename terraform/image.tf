resource "proxmox_download_file" "debian13" {
  content_type       = "import"
  datastore_id       = "local"
  node_name          = "pve"
  url                = "https://cloud.debian.org/images/cloud/trixie/20261103-2651/debian-13-genericcloud-amd64-20261103-2651.qcow2"
  checksum           = "d25999de0770d4cde1be72c299ba3ad94eac7ea8fd4d18f8cc86c69df69337e2e8a91d64465a9bfd8f2a78c566fcbcb0842eacc91c09efdef72d719d9f13b535"
  checksum_algorithm = "sha512"
}
