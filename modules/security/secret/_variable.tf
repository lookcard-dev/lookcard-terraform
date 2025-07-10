
variable "secrets" {
  type = list(string)
  default = [
    "REAP",
    "TRONGRID",
    "FIREBASE",
    "SUMSUB",
    "ELLIPTIC",
    "HAWK",
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
    "DATABASE",
    "WALLET",
    "MICROSOFT",
    "ITRX",
    "TRONENERGY",
    "TRONSAVE",
    "BLAST",
    "PUBLIC_NODE",
    "TELEGRAM",
    "SUPABASE",
    "SMTP",
    "CLOUDFLARE",
    "FUSIONAUTH"
  ]
  nullable = true
}
