data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "ssm" {
  name = "${var.name_prefix}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-ec2-ssm-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${var.name_prefix}-${var.environment}-ec2-ssm-role"
  role = aws_iam_role.ssm.name

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-ec2-ssm-role"
    Environment = var.environment
  }
}

resource "aws_instance" "this" {
  for_each = var.instances

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = each.value.instance_type
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = each.value.security_group_ids
  iam_instance_profile = aws_iam_instance_profile.ssm.name

  associate_public_ip_address = false

  depends_on = [aws_iam_instance_profile.ssm]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-${each.key}"
    Environment = var.environment
  }
}  