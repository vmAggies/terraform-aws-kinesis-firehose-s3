// KMS key
data "aws_iam_policy_document" "kinesis_key_policy" {
  statement {
    sid       = "key access for root user"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
  }

  statement {
    sid    = "access for adminUser"
    effect = "Allow"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["${aws_kinesis_stream.stream.arn}"]

    principals {
      type = "AWS"

      identifiers = "${var.kinesis_admin_iam_users}"
    }
  }

  statement {
    sid    = "Allow the principles to read off the kinesis stream"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["${aws_kinesis_stream.stream.arn}"]

    principals {
      type = "AWS"

      identifiers = "concat(${var.kinesis_read_iam_roles}, ${aws_iam_role.kinesis_stream_read_role.arn})"
    }
  }

  statement {
    sid    = "allow AWS services to use the key if these users delegate permissions"
    effect = "Allow"

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.aws_account_id}:role/adminUser",
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAwsResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "kinesis_key" {
  description             = "KMS Key for ${local.stream_name}"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = "${data.aws_iam_policy_document.kinesis_key_policy.json}"
  is_enabled              = true
  enable_key_rotation     = true
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${local.stream_name}"
  target_key_id = "${aws_kms_key.kinesis_key.key_id}"
}
