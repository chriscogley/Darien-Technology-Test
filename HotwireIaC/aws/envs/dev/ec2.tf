resource "aws_iam_role" "ssm_role" {
  name = "eks-ssm-bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{Effect="Allow", Principal={Service="ec2.amazonaws.com"}, Action="sts:AssumeRole"}]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "eks-ssm-bastion-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_security_group" "bastion_sg" {
  name        = "eks-ssm-bastion-sg"
  description = "Egress to reach EKS control plane privately"
  vpc_id      = module.fng-dev-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "eks_bastion" {
  ami                    = "ami-0aa7db6294d00216f"
  instance_type          = "t4g.micro"
  subnet_id              = "subnet-0099e1cc06ee135df"
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf install -y curl jq

    KVER="$(curl -Ls https://dl.k8s.io/release/stable.txt)"
    curl -LO "https://dl.k8s.io/release/$${KVER}/bin/linux/amd64/kubectl"
    install -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
  EOF

  tags = { Name = "eks-ssm-bastion" }
}

