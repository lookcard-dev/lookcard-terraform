
variable "secret_names" {
  type = list(string)
  default = [
    //* 以下是新secret manager */
    //one2cloud
    "REAP",
    "TRONGRID",
    "FIREBASE",
    "SUMSUB",
    "ELLIPTIC",
    "HAWK",
    "SYSTEM_CRYPTO_WALLET",
    "TWILIO",
    "SENDGRID",
    "COINRANKING",
    "TELEGRAM",
    "SENTRY",
    "QUICKNODE",
    "ANKR",
    "GET_BLOCK",
    "DRPC",
    "INFURA",
    "POSTMARK",
    // evvo lab 
    "ENV",
    "TOKEN", //
    "DATABASE",
    "AML_ENV",
    "CRYPTO_API_ENV",
    "NOTIFICATION_ENV",
    "AGGREGATOR_ENV",
    "DID_PROCESSOR_LAMBDA",
    "DB_MASTER_PASSWORD",
  ]
}