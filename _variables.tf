variable "aws_account_ids" {
    type = map(string)
    default = {
        development = "767828723672"
        production  = "412381738156"
    }
}

variable "vpc_cidr" {
    type = map(string)
    default = {
        development = "10.0.0.0/16"
        production  = "11.0.0.0/16"
    }
}

variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(string)
  default = {
    development = "10.0.1.0/24"
    production  = "11.0.1.0/24"
  }
}

variable "private_subnets" {
  type = map(string)
  default = {
    development = "10.0.2.0/24"
    production  = "11.0.2.0/24"
  }
}

variable "environments" {
  type = map(string)
  default = {
    development = "development"
    production = "production"
  }
}