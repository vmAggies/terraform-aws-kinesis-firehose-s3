# this will contain stuff for creating kinesis streams for environment
// variables definition

// Locals:
locals {
  prefix_stream_name = "${var.aws_account_name}-${var.partner}-${var.environment}-" 
  suffix_stream_name = "${var.valid == 1 ? "valid": "invalid"}-${var.sensitive == 1 ? "sensitive": "non-sensitive"}"

  stream_name = "${local.prefix_stream_name}-${local.suffix_stream_name}" 
}

// kinesis stream definition
resource "aws_kinesis_stream" "stream" {
  name             = "${local.stream_name}"
  shard_count      = "${var.kinesis_shards}"
  retention_period = "${var.kinesis_retention}"

  encryption_type = "KMS"
  kms_key_id      = "${aws_kms_key.kinesis_key.key_id}"
}