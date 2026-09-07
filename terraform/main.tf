terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- Intentionally insecure S3 bucket (no encryption, no versioning, public ACL) ---
resource "aws_s3_bucket" "sample_bucket" {
  bucket = "veracode-iac-sample-bucket"
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "sample_bucket_access" {
  bucket                  = aws_s3_bucket.sample_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# --- Intentionally open security group (0.0.0.0/0 on SSH) ---
resource "aws_security_group" "sample_sg" {
  name        = "veracode-iac-sample-sg"
  description = "Sample SG with overly permissive ingress"

  ingress {
    description = "SSH open to the world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Intentionally overly permissive IAM policy ---
resource "aws_iam_policy" "sample_policy" {
  name        = "veracode-iac-sample-policy"
  description = "Sample overly permissive IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

# --- Unencrypted EBS volume ---
resource "aws_ebs_volume" "sample_volume" {
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = false
}

# --- Hardcoded credential (for secrets scanning; not a real key) ---
variable "sample_db_password" {
  default = "SuperSecretPassword123!"
}
