module "vpc" {
  source = "github.com/credeau/terraform-aws-vpc"
  version = "1.0.0"

  application  = "mobile-forge"
  environment  = "prod"
  region       = "ap-south-1"
  stack_owner  = "tech@credeau.com"
  stack_team   = "devops"
  organization = "credeau"
  vpc_cidr     = "52.52.0.0/16"
  public_subnet_cidrs = [
    {
      "cidr" : "52.52.0.0/20", # 4096 IPs - 52.52.0.1 to 52.52.15.254
      "az" : "ap-south-1a"
    },
    {
      "cidr" : "52.52.16.0/20", # 4096 IPs - 52.52.16.1 to 52.52.31.254
      "az" : "ap-south-1b"
    },
    {
      "cidr" : "52.52.32.0/20", # 4096 IPs - 52.52.32.1 to 52.52.47.254
      "az" : "ap-south-1c"
    }
  ]
  private_subnet_cidrs = [
    {
      cidr = "52.52.48.0/20" # 4096 IPs - 52.52.48.1 to 52.52.63.254
      az   = "ap-south-1a"
    },
    {
      cidr = "52.52.64.0/20" # 4096 IPs - 52.52.64.1 to 52.52.79.254
      az   = "ap-south-1b"
    },
    {
      cidr = "52.52.80.0/20" # 4096 IPs - 52.52.80.1 to 52.52.95.254
      az   = "ap-south-1c"
    }
  ]
  internal_sg_ingress_conf = []
  external_sg_ingress_conf = [
    {
      "description" : "Allow HTTPS traffic from all sources",
      "port" : 443,
      "protocol" : "tcp",
      "cidr" : ["0.0.0.0/0"]
    }
  ]
  bastion_instance_type = "t3a.micro"
  bastion_key_name      = "mobile-forge-demo"
  bastion_ami_id        = null # use latest ubuntu 22.04 AMI
  bastion_allowed_cidrs = ["0.0.0.0/0"]
}

output "vpc" {
  value = module.vpc
}
