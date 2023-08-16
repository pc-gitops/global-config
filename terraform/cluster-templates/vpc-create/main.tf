provider "aws" {
  region = var.region

  default_tags {
    tags = merge({
      source = "Terraform Managed"
    }, var.tags)
  }
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

resource "aws_cloudwatch_log_group" "vpc" {
  name = var.vpc_name
}

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = var.vpc_name
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "expire_old_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id
  prevent_destroy = true

  rule {
    id      = "expire-old-logs"
    status  = "Enabled"
    prefix  = ""
    enabled = true

    transitions {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}


resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_s3_bucket.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc_flow_logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.vpc_flow_logs.name
}

