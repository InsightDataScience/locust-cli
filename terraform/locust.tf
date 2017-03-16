/*
  Locust security group
*/
resource "aws_security_group" "locust" {
    name = "locust"
    description = "locust security group"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8089
        to_port = 8089
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        self = true
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.locust.id}"

    tags {
        Name = "locust"
    }
}

resource "aws_instance" "locust-master" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-west-2a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.locust.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "locust-master"
    }
}

resource "aws_eip" "locust-master" {
    instance = "${aws_instance.locust-master.id}"
    vpc = true
}

resource "aws_instance" "locust-slave" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-west-2a"
    instance_type = "t2.medium"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.locust.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    count = "${var.locust-slave-count}"

    tags {
        Name = "locust-slave"
    }
}

resource "aws_eip" "locust-slave" {
    count = "${var.locust-slave-count}"
    instance = "${element(aws_instance.locust-slave.*.id, count.index)}"
    vpc = true
}
