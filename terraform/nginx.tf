provider "aws" {
	shared_credentials_file  = "C:/Users/admin/.aws/credentials"
	profile                  = "default"
    region = "us-east-1"
}


resource "aws_key_pair" "auth" {
  key_name   = "${lookup(var.keypair, "key_name")}"
  public_key = "${file("${lookup(var.keypair, "public_key")}")}"
}
# Create a VPC to launch our instances into
resource "aws_vpc" "nginx" {
  cidr_block = "10.0.0.0/16"
  tags {  Name = "nginxVPC"  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "nginx" {
  vpc_id = "${aws_vpc.nginx.id}"
  tags {  Name = "nginxGateway"  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.nginx.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.nginx.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "nginx" {
  vpc_id                  = "${aws_vpc.nginx.id}"
  cidr_block              = "10.0.0.0/16"
  map_public_ip_on_launch = true
  tags {  Name = "nginxsubnet"  }
  
}
# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "nginx_elb" {
  name        = "nginx_demo"
  description = "Used for nginx elb"
  vpc_id      = "${aws_vpc.nginx.id}"
  tags {  Name = "nginxelb"  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "nginx" {
  name        = "nginx_sg"
  description = "Used for nginx server"
  vpc_id      = "${aws_vpc.nginx.id}"
  tags {  Name = "demo_nginx_server"}

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  # HTTPS access from the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "nginx" {
  name_prefix   = "nginx-"
  image_id      = "${var.nginx_ami}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.nginx.id}"]
  key_name   = "${lookup(var.keypair, "key_name")}"
  user_data = "${file("./userdata.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx" {
  name                 = "nginx"
  launch_configuration = "${aws_launch_configuration.nginx.name}"
  min_size             = 3
  max_size             = 5
  tag { key = "Name" 
		value = "NginxServerAutoScale"
		propagate_at_launch = true
  }
  vpc_zone_identifier  = ["${aws_subnet.nginx.id}"]
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.nginx.id}"
  elb                    = "${aws_elb.nginxelb.id}"
}
resource "aws_iam_server_certificate" "nginx_ubuntu_cert" {
  name             = "nginx_ubuntu_cert"
  certificate_body = "${file("../cookbooks/nginx/files/ssl/nginx-selfsigned.crt")}"
  private_key      = "${file("../cookbooks/nginx/files/ssl/nginx-selfsigned.key")}"
}
resource "aws_elb" "nginxelb" {
  name = "demonginxelb"
  subnets         = ["${aws_subnet.nginx.id}"]
  security_groups = ["${aws_security_group.nginx_elb.id}"]
  tags {  Name = "nginxserver_elb"  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port     = 443
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
	ssl_certificate_id = "${aws_iam_server_certificate.nginx_ubuntu_cert.arn}"	
  }
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 30
  }  
}
