##########################################################
#Module: S3
#
#Index:
#- Create Bucket
#- S3.1,S3.2 y S3.3
#- S3.4
#- S3.5
#- S3.8
#- S3.9
#- S3.10
#- S3.11
##########################################################

resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
  tags = {
    Name = var.s3_bucket_name
  }
}

########## S3.1, S3.2 y S3.3 ##########
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.main]
}

########## S3.4 ########## PENDIENTE SEGURIDAD

#resource "aws_kms_key" "main" {
#  description = "Key used to encrypt bucket objects"
#}
#
#resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
#  bucket = aws_s3_bucket.main.id
#
#  rule {
#    apply_server_side_encryption_by_default {
#      kms_master_key_id = aws_kms_key.main.arn
#      sse_algorithm     = "aws:kms"
#    }
#  }
#}

########## S3.5 ########## - Pendiente revision Seguridad

#resource "aws_s3_bucket_policy" "main" {
#  bucket = aws_s3_bucket.main.id
#  policy = ""
#}

########## S3.8 ##########
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

########## S3.9 ##########
#resource "aws_s3_bucket_logging" "main" {
#  bucket        = aws_s3_bucket.main.id
#  target_bucket = var.s3_bucket_for_logging
#  target_prefix = var.s3_bucket_for_logging_path
#}

########## S3.10 ########## S3 buckets with versioning enabled should have lifecycle policies configured

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

########### S3.11 ########## - PENDIENTE SEGURIDAD
#resource "aws_s3_bucket_notification" "main" {
#  bucket = aws_s3_bucket.main.id
#
#  topic {
#    events    = ["s3:ObjectCreated:*"]
#    topic_arn = ""
#  }
#}

########### S3.13 ##########
#resource "aws_s3_bucket_lifecycle_configuration" "main" {
#  bucket = aws_s3_bucket.main.id
#}
