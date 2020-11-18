# terraform cloud provider
provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.cloud_assume_role ? local.arn_role : null
    external_id  = var.cloud_assume_role ? var.extenal_id : null
    session_name = var.cloud_assume_role ? var.session_name : null
    #duration_seconds = var.cloud_assume_role ? var.session_duration : null
  }

}

# terraform backend
terraform {
  required_version = "~> 0.12.26"
  backend "s3" {
    bucket         = "s3-tfstate-60303"
    key            = "k8s/network.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-tfstate-lock-60303"
  }
}

data "aws_caller_identity" "current" {}

locals {
  arn_role = "arn:aws:iam::${var.aws_account}:role/tf_role"
  aws_account_id = data.aws_caller_identity.current.account_id
}

data "template_file" "role_trust_policy" {
  template = file("tf_code/policies/user_role_trust_policy.tpl")

  vars = {
    aws_account_id = local.aws_account_id
  }
}

data "template_file" "role_policy" {
  template = file("tf_code/policies/user_role_policy.tpl")

  vars = {
    aws_account_id = local.aws_account_id
    region =var.region
  }
}

resource "aws_iam_role" "secrets_role" {
  name = "secrets_role"
  assume_role_policy = data.template_file.role_trust_policy.rendered
}

resource "aws_iam_role_policy" "default" {
  name = "secrets_policy"
  role = aws_iam_role.secrets_role.id
  policy = data.template_file.role_policy.rendered
}

