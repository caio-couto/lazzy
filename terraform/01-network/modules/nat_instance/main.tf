resource "aws_iam_role" "this" {
  name = local.name

  assume_role_policy = <<EOD
  {
    "Version": "2012-10-17" ,
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOD
}

resource "aws_iam_policy_attachment" "this" {
  name = local.name
  roles = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = aws_iam_role.this.name
}

resource "aws_security_group" "this" {
  name = local.name
  description = "${var.vpc_name} NAT Instance security group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  count = var.nat_instance_count

  ami = data.aws_ami.amazon_linux_2.id 
  instance_type = var.nat_instance_type
  subnet_id = var.public_subnet_ids[count.index]
  associate_public_ip_address = "true"
  source_dest_check = "false"
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.this.id
  user_data = file("${path.module}/scripts/user_data.sh")

  tags = {
    Name = "${var.vpc_name}-az-${local.az_codes[count.index]}"
  }

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "./${path.module}/scripts/check_instance_state.sh ${self.id}"
  }
}