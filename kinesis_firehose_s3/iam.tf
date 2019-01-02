
resource "aws_iam_role" "kinesis_stream_read_role" {
  name               = "IAM read only role for stream - ${local.stream_name}"
  assume_role_policy = "${data.aws_iam_policy_document.kinesis_stream_read_policy_document.json}"
}

data "aws_iam_policy_document" "kinesis_stream_read_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:ReadStream",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:DescribeStream",
    ]

    resources = [
      "arn:aws:kinesis:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stream/${local.stream_name}",
    ]
  }
}

resource "aws_iam_role_policy" "kinesis_stream_read_policy" {
  name   = "${local.stream_name}-read-policy"
  role   = "${aws_iam_role.kinesis_stream_read_role.id}"
  policy = "${data.aws_iam_policy_document.kinesis_stream_read_policy_document.json}"
}

// Kinesis Stream Write Only Role and Policy for Producer
