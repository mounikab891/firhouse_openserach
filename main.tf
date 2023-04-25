provider "aws" {
  region                    = "ap-south-1"
  shared_credentials_files  = ["/Users/mounikabethu/.aws/credentials"]
  profile                   = "medibuddy"
}
#resource "aws_s3_bucket" "this_bucket" {
  #bucket = "s3-logs-platform"
#}

resource "aws_s3_object" "object" {
  bucket = var.bucket
  key    = "stg-mb-logs-meds/"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "firehose" {
  name               = "firehose_opensearch"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "firehose-opensearch" {
  name   = "opensearch"
  role   = aws_iam_role.firehose.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "es:*"
      ],
      "Resource": [
        "arn:aws:es:ap-south-1:247653494814:domain/*"
      ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeVpcs",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface"
          ],
          "Resource": [
            "*"
          ]
        }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "test" {
  depends_on = [aws_iam_role_policy.firehose-opensearch]

  name        = "stg-mb-logs-meds"
  destination = "opensearch"
  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = var.bucket_arn
    prefix     = var.s3_prefix
    
  }
  opensearch_configuration {
    domain_arn = var.opensearch_domain_arn
    role_arn   = aws_iam_role.firehose.arn
    index_name = var.index_name

    vpc_config {
      security_group_ids = [var.security_group_id]
      subnet_ids         = [var.aws_subnet]
      role_arn           = aws_iam_role.firehose.arn
    }
  }
}






  
