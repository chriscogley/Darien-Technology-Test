##########################################################
#Module: AMI
#
#Index:
#- Create instance with root block device
#- Enables encryption by default
##########################################################

resource "aws_ami" "main" {
  name                = var.ami_name
  description         = var.ami_description
  architecture        = var.ami_architecture
  virtualization_type = var.ami_virtualization_type
  root_device_name    = var.ami_root_name
  imds_support        = var.ami_imds_support

  ebs_block_device {
    device_name           = var.ebs_device_name
    snapshot_id           = var.ebs_snapshot_id
    volume_size           = var.ebs_volume_size
    volume_type           = var.ebs_volume_type
    throughput            = var.ebs_throughput
    iops                  = var.ebs_iops
    encrypted             = var.ebs_encrypted
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name = var.ami_name
  }

}