/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:eu-west-1:780356874729:environment/my-dev-env

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.ping_topic.arn

  policy = data.aws_iam_policy_document.ping_topic_policy.json
}

data "aws_iam_policy_document" "ping_topic_policy" {
  statement {
    effect = "Allow"

    actions = ["sns:Subscribe"]

    condition {
      test     = "StringEquals"
      variable = "sns:Protocol"
      values   = ["sqs"]
    }

    principals {
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
      type        = "AWS"
    }

    resources = [aws_sns_topic.ping_topic.arn]
  }
}