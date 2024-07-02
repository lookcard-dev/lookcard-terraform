resource "aws_kms_key" "wallet_encryption" {
  description              = "KMS key for wallet encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "wallet_encryption"
  }
}

resource "aws_kms_key_policy" "wallet_encryption_policy" {
  key_id = aws_kms_key.wallet_encryption.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::576293270682:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow specific IAM Role",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.lookcard_ecs_task_role.arn
        },
        "Action" : "kms:*",
        "Resource" : aws_kms_key.wallet_encryption.arn
      }
    ]
  })
}

resource "aws_kms_alias" "wallet_encryption_alias" {
  name          = "alias/wallet_encryption"
  target_key_id = aws_kms_key.wallet_encryption.id
}

resource "aws_kms_key" "crypto_api_encryption" {
  description              = "KMS key for crypto API encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "crypto_api_encryption"
  }
}

resource "aws_kms_key_policy" "crypto_api_encryption_policy" {
  key_id = aws_kms_key.crypto_api_encryption.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "crypto-api-encryption-key",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::576293270682:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}


resource "aws_kms_alias" "crypto_api_encryption_alias" {
  name          = "alias/crypto_api_encryption"
  target_key_id = aws_kms_key.crypto_api_encryption.id
}

resource "aws_kms_key" "crypto_api_generator" {
  description              = "KMS key for crypto API encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "crypto-api-generator"
  }
}


resource "aws_kms_key_policy" "crypto_api_generator_policy" {
  key_id = aws_kms_key.crypto_api_generator.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "crypto-api-generator-key",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::576293270682:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}


resource "aws_kms_alias" "crypto_api_generator_alias" {
  name          = "alias/crypto-api-generator"
  target_key_id = aws_kms_key.crypto_api_generator.id
}

