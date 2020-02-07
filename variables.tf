variable "access_key" {}
variable "secret_key" {}
# variable "public_key" {}

variable "region" {default = "us-east-2"}
variable "ami" {default = "ami-0833104f83deab338"}
variable "t2shape" {default = "t2.micro"}

variable "servername1" {
  description = "Namesfor instance"
  default = "win_serv1"
}

variable "servername2" {
  description = "Namesfor instance"
  default = "win_serv2"
}

variable "bucket_name" {
  default = "globallogicbucket"
}

variable "cidr_block" {
  type = string
  description = "VPC Networks pool space"
  default = "192.168.0.0/16"
}

variable "cidr_block_subnet1" {
  type = string
  description = "Subnet pool space"
  default = "192.168.1.0/24"
}

variable "cidr_block_subnet2" {
  type = string
  description = "Subnet pool space"
  default = "192.168.2.0/24"
}

variable "az1" {
  default = "us-east-2a"
}

variable "az2" {
  default = "us-east-2b"
}

# variable "subnet_id" {
#   description = "My subnet ID"
#   type = "string"
# }
