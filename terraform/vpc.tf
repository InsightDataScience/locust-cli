/*
  VPC
*/
resource "aws_vpc" "locust" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "locust"
    }
}

/*
  IGW
*/
resource "aws_internet_gateway" "locust" {
    vpc_id = "${aws_vpc.locust.id}"

    tags {
        Name = "locust"
    }
}

/*
  Public Subnet in VPC
*/
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.locust.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2a"

    tags {
        Name = "locust"
    }
}

resource "aws_route_table" "locust" {
    vpc_id = "${aws_vpc.locust.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.locust.id}"
    }

    tags {
        Name = "locust"
    }
}

resource "aws_route_table_association" "locust" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.locust.id}"
}

