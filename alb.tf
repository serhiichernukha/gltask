resource "aws_lb" "test" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow.id]
  subnets            = ["${aws_subnet.my-subnet1.id}", "${aws_subnet.my-subnet2.id}"]

  # enable_deletion_protection = true

  tags = {
    Environment = "test"
  }
}
