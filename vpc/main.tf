resource "aws_vpc" "test-vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    instance_tenancy = var.instance_tenancy
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.test-vpc.id
    cidr_block = var.public_subnet_cidr_block
    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.test-vpc.id
    cidr_block = var.private_subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.test-vpc.id
    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.test-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.vpc_name}-public-route-table"
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}