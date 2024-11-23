terraform {
  backend "vault" {
    address = "https://vault-cluster-public-vault-249803a1.b1903010.z1.hashicorp.cloud:8200"
    path    = "secret/terraform/${terraform.workspace}/state" # Dynamic path for workspace
    token   = var.vault_token # Vault token stored in GitHub Actions secrets
  }
}
provider "vault" {
    address = "https://vault-cluster-public-vault-249803a1.b1903010.z1.hashicorp.cloud:8200"
}

provider "aws" {
    region = var.region
    assume_role {
    role_arn = format("arn:aws:iam::%s:role/CrossAccountDeployRole", var.aws_account_ids[terraform.workspace])
    }
 }
data "vault_generic_secret" "backend" {
  path = "secret/terraform/${terraform.workspace}"
}

