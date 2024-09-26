Terraform module to provision an EC2 that is running apache

Not intended for production use just showcasing how to create a custom module on terraform registry

```hcl

provider "aws" {
  region = "us-east-1"
}

module "apache" {
  source          = ".//terraform-aws-apache-example"
  vpc_id          = "vpc-ID"
  my_ip_with_cidr = "MY_IP_ADDRESS/0"
  public_key      = "ssh-rsa AAAAB...."
  instance_type   = "t2.micro"
  server_name     = "Apache Example Server"
}

output "public_ip" {
  value = module.apache.public_ip
}
```
