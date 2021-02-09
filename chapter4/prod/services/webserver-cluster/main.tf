
# Partial configuration. The other settings (e.g. bucket, region) will be
# passed in from a file via -backend-config arguments to 'terraform init'
terraform {
    backend "s3" {
        key = "prod/services/webserver-cluster/terraform.tfstate"
    }
}

provider "aws" {
    region = "eu-central-1"
}

module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
    source = "git@github.com/artpropp/terraform-modules.git/services/webserver-cluster?rev=v0.1.0"

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "terraform-up-and-running-arp-state"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

    instance_type = "t3.micro"
    min_size = 2
    max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}