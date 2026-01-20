# AWS VPC Module

This Terraform module creates a complete VPC (Virtual Private Cloud) infrastructure on AWS with public and private subnets, internet gateway, and route tables.

## Features

- Creates a VPC with configurable CIDR block
- Sets up public and private subnets
- Creates an Internet Gateway for public internet access
- Configures route tables for public and private subnets
- Supports custom VPC naming and tagging
- Configurable DNS settings
- Supports instance tenancy configuration

## Components

1. **VPC**
   - Custom CIDR block
   - DNS support and hostname settings
   - Instance tenancy configuration

2. **Subnets**
   - Public subnet with internet access
   - Private subnet for internal resources
   - Configurable CIDR blocks for each subnet
   - Availability zone configuration

## Network Architecture Overview

### Subnet Types

#### Public Subnets
- **Purpose**: Host resources that need direct internet access (e.g., web servers, load balancers)
- **Key Characteristics**:
  - Has a route to an Internet Gateway (IGW)
  - Resources can have public IP addresses
  - Can be directly accessed from the internet (if security groups allow)
  - Used for load balancers, bastion hosts, and NAT gateways

#### Private Subnets
- **Purpose**: Host resources that should not be directly accessible from the internet
- **Key Characteristics**:
  - No direct route to the internet
  - Resources can access the internet through a NAT Gateway (outbound only)
  - Used for application servers, databases, and other internal services
  - More secure as they're not directly exposed to the public internet

### Internet Gateway (IGW)
- **Purpose**: Provides a target in your VPC route tables for internet-routable traffic
- **Key Functions**:
  - Enables communication between resources in your VPC and the internet
  - Performs network address translation (NAT) for instances with public IPv4 addresses
  - Horizontally scaled, redundant, and highly available VPC component
  - Provides a target in public subnet route tables for internet-bound traffic

### NAT Gateway
- **Purpose**: Enables instances in private subnets to connect to the internet
- **Key Characteristics**:
  - Must be created in a public subnet
  - Requires an Elastic IP address
  - Provides outbound internet connectivity for private subnets
  - Managed service with built-in redundancy
  - More secure than NAT instances (no security groups or instances to manage)

### How They Work Together
1. **Public Subnet Traffic**:
   - Resources in public subnets use the IGW for direct internet access
   - Inbound traffic is allowed through security groups and network ACLs

2. **Private Subnet Traffic**:
   - Resources in private subnets send outbound traffic to the NAT Gateway
   - The NAT Gateway forwards the traffic to the IGW
   - Return traffic is routed back through the NAT Gateway
   - Inbound traffic from the internet is blocked (unless specifically allowed)

### Security Considerations
- **Public Subnets**:
  - Use security groups and network ACLs to restrict access
  - Only expose necessary ports to the internet
  - Consider using Web Application Firewall (WAF) for additional protection

- **Private Subnets**:
  - More secure by default as they're not directly accessible
  - Still require proper security group configurations
  - Can be further isolated using VPC endpoints for AWS services

### Best Practices
1. **Subnet Sizing**:
   - Plan CIDR blocks carefully to allow for future growth
   - Consider using smaller subnets (/24 or /26) for better security segmentation

2. **High Availability**:
   - Deploy NAT Gateways in multiple availability zones
   - Use multiple public/private subnets across different AZs

3. **Security**:
   - Use Network ACLs as a secondary defense layer
   - Implement VPC Flow Logs for monitoring network traffic
   - Regularly review and update security group rules
   - Internet Gateway for public subnet internet access
   - Route tables for traffic routing
   - Route table associations

## Usage

```hcl
module "vpc" {
  source = "./vpc"
  
  vpc_name                  = "my-vpc"
  cidr_block               = "10.0.0.0/16"
  enable_dns_support       = true
  enable_dns_hostnames     = true
  instance_tenancy         = "default"
  public_subnet_cidr_block = "10.0.1.0/24"
  private_subnet_cidr_block = "10.0.2.0/24"
  availability_zone        = "us-west-2a"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| vpc_name | Name of the VPC | string | - | yes |
| cidr_block | CIDR block for the VPC | string | - | yes |
| enable_dns_support | Enable DNS support | bool | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames | bool | `true` | no |
| instance_tenancy | Instance tenancy for the VPC | string | `"default"` | no |
| public_subnet_cidr_block | CIDR block for the public subnet | string | - | yes |
| private_subnet_cidr_block | CIDR block for the private subnet | string | - | yes |
| availability_zone | Availability zone for the subnets | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| public_subnet_id | The ID of the public subnet |
| private_subnet_id | The ID of the private subnet |
| internet_gateway_id | The ID of the Internet Gateway |
| public_route_table_id | The ID of the public route table |

## Best Practices

1. Always use meaningful names for your VPC and its components
2. Use non-overlapping CIDR blocks for your VPC and subnets
3. Consider using multiple availability zones for high availability
4. Use tags consistently for resource management and cost allocation
5. Follow the principle of least privilege when configuring security groups and NACLs

## Requirements

- Terraform 0.12 or newer
- AWS Provider 3.0 or newer
- AWS credentials configured with appropriate permissions
