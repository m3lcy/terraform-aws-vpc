resource "aws_flow_log" "this" {
  count                = var.enable_flow_logs ? 1 : 0
  vpc_id               = aws_vpc.this.id
  traffic_type         = var.flow_log_traffic_type
  log_destination_type = "s3"
  log_destination      = "${aws_s3_bucket.flow_logs[0].arn}/flow-logs/"

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "flow_logs" {
  count  = var.enable_flow_logs ? 1 : 0
  bucket = "${var.name_prefix}-${var.environment}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name        = "${var.name_prefix}-${var.environment}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "flow_logs" {
  count  = var.enable_flow_logs ? 1 : 0
  bucket = aws_s3_bucket.flow_logs[0].id
  policy = data.aws_iam_policy_document.flow_logs[0].json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  statement {
    sid    = "AllowVPCFlowLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.flow_logs[0].arn}/flow-logs/AWSLogs/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "AllowAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.flow_logs[0].arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}