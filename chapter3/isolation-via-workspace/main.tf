terraform {
    backend "s3" {
        key = "isolation-via-workspace/terraform.tfstate"
    }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-0c960b947cbb2dd16"
  instance_type = terraform.workspace == "default" ? "t3.micro" : "t2.nano"
}