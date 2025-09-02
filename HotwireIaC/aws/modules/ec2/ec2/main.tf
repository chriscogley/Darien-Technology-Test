##########################################################
#Module: EC2
#
#Index:
#- Create instance with root block device
#- Enables encryption by default
##########################################################

resource "aws_instance" "main" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  availability_zone      = var.ec2_az
  subnet_id              = var.ec2_subnet
  ebs_optimized          = var.ec2_ebs_optimized
  iam_instance_profile   = var.ec2_iam_instance_profile
  key_name               = var.ec2_key_name
  monitoring             = var.ec2_monitoring
  vpc_security_group_ids = var.ec2_securitygroups
  user_data              = var.ec2_user_data

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    throughput  = var.ebs_throughput
    iops        = var.ebs_iops

    tags = {
      Name = var.ec2_instance_name
    }

  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = var.ec2_metadata_hops
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  tags = {
    Name = var.ec2_instance_name
  }

}