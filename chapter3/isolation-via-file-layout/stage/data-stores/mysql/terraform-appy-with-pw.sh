#!/bin/bash
export TF_VAR_db_password=$(pass database-password)
terraform apply
