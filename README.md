# Terraform Training

This little repository comprises lessons learned together with code from following along the book
[Terraform: Up & Running](https://www.terraformupandrunning.com) from Yevgeniy Brikman.
My big thank-you goes out to [Yevgeniy Brikman](https://github.com/brikis98/).

All Terraform code is geared towards AWS (Amazon Web Services) EC2 (Elastic Compute Cloud) instances,
and ASG (Auto-Scaling Groups) in later chapters.

For persisting state, we use here a S3 bucket, in which we encrypt and persist the state for different environments.
Yours has to have a different name, as those have to be unique across all AWS, not only within a tenant/account.
To avoid concurrent infrastructure modification a lock entry is set within a DynamoDB table.
Please refer to the backend.hcl in chapter 3 and 4 respectively. There we refer to the S3 bucket,
and the DynamoDB table.

This setup allows for cooperation and synchronization within a team, although the clear recommendation is to use some
central GitOps focused automation, like a build pipeline, that modifies the infrastructure
only after a successful commit, i.e. with passed quality guards.

Each subdirectory/chapter focuses on different aspects. 
`chapter2` focuses on a basic infrastructure with

* an ASG with 2 to 10 instances of the chosen EC2 instances, within the default Virtual Private Cloud (VPC) network
* a Load Balancer (LB), with health checks towards the ASG
* a Security group, with quite permissive (with respect to the IP range) ingress/egress rules for port 80 only

In `chapter3` we explore different strategies on how to store the state for different stages/environments.
These are mainly

* isolation via file layout, i.e. tree structure which provides a clear visual understanding at first grasph
* isolation via workspaces, which can be created/set with the `terraform workspace` command.
  For more information, simply invoke `terraform workspace --help`

`chapter4` gets more involved as it dives deep into Terraform module development and unit testing. This is where
the meat of this repository lies. The "unit tests" are more like integration tests, as they run against the real,
deployed infrastructure and poll for certain endpoints. The basic structure of this chapter's directory shows
* a `global` directory with the state file configuration on S3 (similar to the isolation via file layout from chapter2)
* a `modules` directory with the abstraction a webserver cluster into a module, that is used the following directories
* `prod` and `stage` directories with different configurations.
  Here, the main difference is that the prod structure contains a scale-out and scale-in scheduling

One remark about the `modules` directory within `chapter4`, which just a stub. The modules as referred to in the
different configuration of the stages is places also within this same repository.
More modules with tests are placed in a separate repository, which I will 
upload [here](https://github.com/artpropp/terraform-aws-modules).
These can then be referred to with

```terraform
module "webserver_cluster" {
  source = "git@github.com/artpropp/terraform-modules.git/services/webserver-cluster?rev=v0.1.0"
  ...
}
```

## Now you try it

So, what do I need to try these steps on my own?

First, you need an AWS account, which allows you to play through the examples. You can work with the examples here
for free if you create the account for the first time and use the Free Tier offer for 12 months. Apart from this,
if you don't let your instances run only for a short amount of time you will only incur a small fee.

> Disclaimer: I don't take responsibility for any costs incurred on your end.
> Please study the pricing information on AWS before running blindly some code.

Also, not mentioned here is the way to set up the S3 bucket and the policies.

> Please don't use your root AWS account to create tokens to use with your AWS CLI or Terraform.
> Limit any risk by creating a user with limited scope first, and then use the API tokens of that user.

You need the following IAM (Identity & Access Management) policies for your user:
* `AmazonEC2FullAccess` for `chapter2`
* additionally, `AmazonS3FullAccess`, `AmazonDynamoDBFullAccess`, and `AmazonRDSFullAccess`
  for `chapter3`, and `chapter4`