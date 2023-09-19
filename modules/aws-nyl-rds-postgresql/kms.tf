resource "aws_kms_key" "rds_kms" {
  description = "KMS for RDS encryption"
}

resource "aws_kms_alias" "rds_kms_alias" {
  name          = "alias/nyl-${var.lob}-${var.env}-cmk"
  target_key_id = aws_kms_key.rds_kms.key_id
}

resource "aws_kms_key_policy" "rds_kms_policy" {
  key_id = aws_kms_key.rds_kms.key_id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Sid": "Allow an external account to use this KMS key",
        "Effect": "Allow",
        "Principal": {
            "AWS": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
        },
        "Action": "kms:*",
        "Resource": "*"
      }
  ]
}
EOF
  
}