provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "example" {
    ami = "ami-0c960b947cbb2dd16"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = "${file("simple-web-script.sh")}"

    tags = {
        Name = "terraform-example-rename"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}