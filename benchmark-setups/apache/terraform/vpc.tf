/*
  VPC
*/
resource "aws_vpc" "apache" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "apache"
    }
}

/*
  IGW
*/
resource "aws_internet_gateway" "apache" {
    vpc_id = "${aws_vpc.apache.id}"

    tags {
        Name = "apache"
    }
}

/*
  Public Subnet in VPC
*/
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.apache.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2a"

    tags {
        Name = "apache"
    }
}

resource "aws_route_table" "apache" {
    vpc_id = "${aws_vpc.apache.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.apache.id}"
    }

    tags {
        Name = "apache"
    }
}

resource "aws_route_table_association" "apache" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.apache.id}"
}

