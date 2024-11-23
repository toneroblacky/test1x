locals {

    tags = {
        CreatedBy : "Terraform"
        Workspace : terraform.workspace
        Environment: var.environments[terraform.workspace]
    }
}