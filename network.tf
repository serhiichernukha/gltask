resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
  Name = "globalvpc"
  }
}

resource "aws_subnet" "my-subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr_block_subnet1
  map_public_ip_on_launch = "true"
  availability_zone = var.az1
  tags = {
  Name = "subnet-1"
  }
}

resource "aws_subnet" "my-subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr_block_subnet2
  map_public_ip_on_launch = "true"
  availability_zone = var.az2
  tags = {
  Name = "subnet-2"
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_internet_gateway" "myvpc_gw" {
    vpc_id = aws_vpc.myvpc.id

}
#
# resource "aws_route_table" "route_my-subnet" {
#     vpc_id = aws_vpc.myvpc.id
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.myvpc_gw.id
#     }
#
#
# }
# resource "aws_route_table_association" "assoc_route_subnet" {
#     subnet_id = aws_subnet.my-subnet.id
#     route_table_id = aws_route_table.route_my-subnet.id
# }
