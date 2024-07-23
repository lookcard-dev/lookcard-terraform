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
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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



resource "aws_kms_key" "data_generator_key" {
  description              = "KMS key for data api and account api encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "data-generator-key"
  }
}

resource "aws_kms_key_policy" "data_generator_key_policy" {
  key_id = aws_kms_key.data_generator_key.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "data-generator-key",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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

resource "aws_kms_alias" "data_generator_key_alias" {
  name          = "alias/data-generator-key"
  target_key_id = aws_kms_key.data_generator_key.id
}

resource "aws_kms_key" "data_encryption_key_alpha" {
  description              = "KMS key for data api and account api encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "data-encryption-key/alpha"
  }
}

resource "aws_kms_key_policy" "data_encryption_key_alpha_policy" {
  key_id = aws_kms_key.data_encryption_key_alpha.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "data-encryption-key-alpha",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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

resource "aws_kms_alias" "data_encryption_key_alpha_alias" {
  name          = "alias/data-encryption-key-alpha"
  target_key_id = aws_kms_key.data_encryption_key_alpha.id
}