terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.9.2, < 5.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = module.base.github_owner
  token = var.github_token
}

module "base" {
  source           = "app.terraform.io/MadeiraMadeira/base/aws"
  version          = "3.0.14"
  environment_name = var.environment_name
}

locals {
  common_tags = {
    App = var.app_name
    Env = var.environment_name
  }
  secrets_name = var.secrets_name == "" ? "${var.app_name}-${var.environment_name}" : var.secrets_name
}