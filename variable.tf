variable "vpc" {
    default = "XXXXX"
}

variable "security_group_id" {
    default = "sg-XXXXXX"
}
variable "aws_subnet" {
    default = "subnet-xxxxxxxx"
}

variable "index_name" {
    default = "stg-xxxxxxxx"
}

variable "firehose_name" {
    default = "stg-xxxxxxxx"
}

variable "domain_name" {
    default = "stg-xxxxxxxx"
}
variable "bucket_arn" {
    default = "arn:aws:s3:::s3-xxxxxxxx"
}
variable "opensearch_domain_arn" {
    default = "arn:aws:es:xxxxxxxx:xxxxxxxx"
}
 
variable "s3_prefix" {
    default = "stg-xxxxxxxx"
}
variable "bucket" {
    default = "s3-xxxxxxxx"
}
variable "key" {
    default = "stg-xxxxxxxx/"
}
