locals {
  cloud_image_catalog = {
    "ubuntu-22-04" = {
      url       = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      file_name = "ubuntu-22.04-cloudimg.img"
    }
    "ubuntu-24-04" = {
      url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
      file_name = "ubuntu-24.04-cloudimg.img"
    }
    "ubuntu-26-04" = {
      url       = "https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img"
      file_name = "ubuntu-26.04-cloudimg.img"
    }
    "debian-12" = {
      url       = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
      file_name = "debian-12-cloudimg.img"
    }
  }
}