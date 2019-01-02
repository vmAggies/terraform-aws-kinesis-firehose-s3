variable "environment" {
  type    = "string"
  default = "staging"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "aws_account_name" {
  type    = "string"
  default = "core"
}

variable "partner" {
  type    = "string"
  default = "us" // US, GSK, Apple, uSwitch, Zillow
}

variable "valid" {
  type = "bool"
  default = 0
}

variable "sensitive" {
  type = "bool"
  default = 0
}

variable "kinesis_shards" {
  default = 4
}

variable "kinesis_retention" {
  default = 24
}

variable "kinesis_read_iam_roles" {
  type = "list"
}

variable "kinesis_write_iam_roles" {
  type = "list"
}

variable "kinesis_admin_iam_users" {
  type = "list"
}
