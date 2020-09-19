# Partial configuration. The other settings (e.g. bucket, region) will be
# passed in from a file via -backend-config arguments to 'terraform init'
terraform {
    backend "s3" {
        key = "stage/data-stores/mysql/terraform.tfstate"
    }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "example_database"
    username = "admin"

    # How should we set the password?
    password = var.db_password
}