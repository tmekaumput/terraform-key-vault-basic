terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "microlabs-info"

    workspaces {
      name = "terraform-key-vault-basic"
    }
  }
}
