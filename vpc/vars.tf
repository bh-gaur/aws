variable "vpc_name" {
    description = "Name of the VPC"
    type = string
}

variable "cidr_block" {
    description = "CIDR block for the VPC"
    type = string
}

variable "enable_dns_support" {
    description = "Enable DNS support for the VPC"
    type = bool
    default = true
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames for the VPC"
    type = bool
    default = true
}

variable "instance_tenancy" {
    description = "Instance tenancy for the VPC"
    type = string
    default = "default"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the public subnet 1"
    type = string
}

variable "availability_zone" {
    description = "Availability zone for the subnet"
    type = string
}

variable "private_subnet_cidr_block" {
    description = "CIDR block for the private subnet 1"
    type = string
}

