# configure cloud provider
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::961857703676:role/tf-role"
  }
}

# terraform backend
terraform {
  backend "s3" {
    bucket         = "s3-tfstate-95653"
    key            = "assume-role/assume-role.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-tfstate-lock-95653"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-039a49e70ea773ffc"
  instance_type = "t2.micro"
}


output "ec1_instance" {
  value = aws_instance.foo.arn
}