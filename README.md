# lightsail-compose

install [terraform](https://www.terraform.io/): ```brew install terraform```

insall wp on:
   * ubuntu: ```terraform apply -auto-approve -var-file=terraform/ubuntu.tfvars terraform/```
   * aws ami:```terraform apply -auto-approve -var-file=terraform/aws.tfvars terraform/```

destroy wp on:
   * ubuntu: ```terraform destroy -auto-approve -var-file=terraform/ubuntu.tfvars terraform/```
   * aws ami: ```terraform destroy -auto-approve -var-file=terraform/aws.tfvars terraform/```


or run on local machine:

```docker-compose up -d```
