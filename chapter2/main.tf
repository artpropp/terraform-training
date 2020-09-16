provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "example" {
    ami = "ami-0c960b947cbb2dd16"
    instance_type = "t3.micro"

    tags = {
        Name = "terraform-example"
    }
}