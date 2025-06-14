<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.bastion_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.external_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | application name to refer and mnark across the module | `string` | `"default"` | no |
| <a name="input_bastion_ami_id"></a> [bastion\_ami\_id](#input\_bastion\_ami\_id) | AMI ID for bastion (if not provided, latest Ubuntu 22.04 AMI will be used) | `string` | `null` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | Instance type for bastion | `string` | `"t3.micro"` | no |
| <a name="input_bastion_key_name"></a> [bastion\_key\_name](#input\_bastion\_key\_name) | Key name for bastion | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment type | `string` | `"dev"` | no |
| <a name="input_external_sg_ingress_conf"></a> [external\_sg\_ingress\_conf](#input\_external\_sg\_ingress\_conf) | Configuration for ingress in external sg | `list(any)` | <pre>[<br>  {<br>    "cidr": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow HTTPS traffic from all sources",<br>    "port": 443,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| <a name="input_internal_sg_ingress_conf"></a> [internal\_sg\_ingress\_conf](#input\_internal\_sg\_ingress\_conf) | Configuration for ingress in internal sg | `list(any)` | `[]` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | organization name | `string` | `"credeau"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | A map of CIDR's - AZ to attach with VPC's private subnets | `list(map(string))` | <pre>[<br>  {<br>    "az": "ap-south-1a",<br>    "cidr": "52.52.48.0/20"<br>  },<br>  {<br>    "az": "ap-south-1b",<br>    "cidr": "52.52.64.0/20"<br>  },<br>  {<br>    "az": "ap-south-1c",<br>    "cidr": "52.52.80.0/20"<br>  }<br>]</pre> | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | A map of CIDRs - AZ to attach with VPC's public subnet | `list(map(string))` | <pre>[<br>  {<br>    "az": "ap-south-1a",<br>    "cidr": "52.52.0.0/20"<br>  },<br>  {<br>    "az": "ap-south-1b",<br>    "cidr": "52.52.16.0/20"<br>  },<br>  {<br>    "az": "ap-south-1c",<br>    "cidr": "52.52.32.0/20"<br>  }<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | aws region to use | `string` | `"ap-south-1"` | no |
| <a name="input_stack_owner"></a> [stack\_owner](#input\_stack\_owner) | owner of the stack | `string` | `"tech@credeau.com"` | no |
| <a name="input_stack_team"></a> [stack\_team](#input\_stack\_team) | team of the stack | `string` | `"devops"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR to attach with vpc | `string` | `"52.52.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host"></a> [bastion\_host](#output\_bastion\_host) | public ip address of bastion |
| <a name="output_bastion_security_group"></a> [bastion\_security\_group](#output\_bastion\_security\_group) | bastion external security group id |
| <a name="output_external_security_group"></a> [external\_security\_group](#output\_external\_security\_group) | external security group id |
| <a name="output_internal_security_group"></a> [internal\_security\_group](#output\_internal\_security\_group) | internal security group id |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | internet gateway id |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | nat gateway id |
| <a name="output_nat_public_ip"></a> [nat\_public\_ip](#output\_nat\_public\_ip) | public ip address of nat gateway |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | private subnet id's |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | public subnet id's |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc id |
<!-- END_TF_DOCS -->