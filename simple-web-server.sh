#!/bin/bash
echo "Hello World! Greetings by Terraform" > index.html
nohup busibox httpd -f -p 8080 &
