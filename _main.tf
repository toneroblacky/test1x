terraform {
  backend "s3" {
    bucket         = "boocampusers"  
    key            = "${terraform.workspace}/terraform.tfstate" 
    region         = "eu-west-1"  
    dynamodb_table = "terraform-lockss" 
    encrypt        = true  
  }
}

provider "aws" {
    region = var.region
    assume_role {
    role_arn = format("arn:aws:iam::%s:role/CrossAccountDeployRole", var.aws_account_ids[terraform.workspace])
    }
}


