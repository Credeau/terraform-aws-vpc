# -----------------------------------------------
# Application and Environment Variables
# -----------------------------------------------
variable "application" {
  type        = string
  description = "application name to refer and mnark across the module"
  default     = "default"
}

variable "environment" {
  type        = string
  description = "environment type"
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod", "uat"], var.environment)
    error_message = "Environment must be one of: dev, prod, or uat."
  }
}

variable "region" {
  type        = string
  description = "aws region to use"
  default     = "ap-south-1"
}

variable "stack_owner" {
  type        = string
  description = "owner of the stack"
  default     = "tech@credeau.com"
}

variable "stack_team" {
  type        = string
  description = "team of the stack"
  default     = "devops"
}

variable "organization" {
  type        = string
  description = "organization name"
  default     = "credeau"
}

# -----------------------------------------------
# Networking Variables
# -----------------------------------------------
variable "vpc_cidr" {
  type        = string
  description = "CIDR to attach with vpc"
  default     = "52.52.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(map(string))
  description = "A map of CIDRs - AZ to attach with VPC's public subnet"
  default = [
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
}

variable "private_subnet_cidrs" {
  type        = list(map(string))
  description = "A map of CIDR's - AZ to attach with VPC's private subnets"
  default = [
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
}

# -----------------------------------------------
# Security Variables
# -----------------------------------------------
variable "internal_sg_ingress_conf" {
  type        = list(any)
  description = "Configuration for ingress in internal sg"
  default     = []
}

variable "external_sg_ingress_conf" {
  type        = list(any)
  description = "Configuration for ingress in external sg"
  default = [
    {
      "description" : "Allow HTTPS traffic from all sources",
      "port" : 443,
      "protocol" : "tcp",
      "cidr" : ["0.0.0.0/0"]
    }
  ]
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type for bastion"
  default     = "t3.micro"
}

variable "bastion_key_name" {
  type        = string
  description = "Key name for bastion"
}

variable "bastion_ami_id" {
  type        = string
  description = "AMI ID for bastion (if not provided, latest Ubuntu 22.04 AMI will be used)"
  default     = null
}

variable "bastion_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access the bastion host via SSH"
  default     = ["0.0.0.0/0"]
}
