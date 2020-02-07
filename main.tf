terraform {
  required_version = ">=0.12"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_instance" "win_web1" {
ami = var.ami
iam_instance_profile = "${aws_iam_instance_profile.my_profile.name}"
vpc_security_group_ids = ["${aws_security_group.allow.id}"]
subnet_id = tolist(data.aws_subnet_ids.all.ids)[0]
instance_type = var.t2shape
tags = {
 Name = var.servername1
 }
key_name = "terraform-key"
user_data = file("./provisioning/userdata1.ps1")
}

resource "aws_instance" "win_web2" {
ami = var.ami
iam_instance_profile = "${aws_iam_instance_profile.my_profile.name}"
vpc_security_group_ids = ["${aws_security_group.allow.id}"]
subnet_id = tolist(data.aws_subnet_ids.all.ids)[1]
instance_type = var.t2shape
tags = {
 Name = var.servername2
 }
key_name = "terraform-key"
user_data = file("./provisioning/userdata2.ps1")
}

resource "aws_security_group" "allow" {
    name = "allow"
    description = "allow rdp protocol and http trafic"
    vpc_id      = "${aws_vpc.myvpc.id}"

    ingress {
      from_port = 3389
      to_port   = 3389
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
