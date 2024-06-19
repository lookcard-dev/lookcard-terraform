aws_provider = {
  region     = "ap-southeast-1"
  account_id = "576293270682"
}
general_config = {
  env    = "testing"
  domain = "test.lookcard.io"
}
dns_config = {
  hostname       = "app"
  api_hostname   = "api"
  admin_hostname = "admin"
}
s3_bucket = {
  ekyc_data          = "lookcard-ekyc"
  alb_log            = "lookcard-alb-logging"
  cloudfront_log     = "lookcard-cloudfront-logging"
  vpc_flow_log       = "lookcard-vpc-flowlog-lookcard"
  aml_code           = "lookcard-lambda-aml-code"
  front_end_endpoint = "testing.lookcard.io"
}
lambda_code = {
  websocket_connect_s3key    = "AM_Websocket_connection.zip"
  websocket_disconnect_s3key = "AM_Websocket_disconnect.zip"
  data_process_s3key         = "lookcard-dataprocess.zip"
  elliptic_s3key             = "lookcard-elliptic.zip"
  push_message_s3key         = "lookcard-websocket.zip"
  push_notification_s3key    = "lookcard-pushnoification.zip"
  withdrawal_s3key           = "lookcard-withdrawal.zip"
}
network = {
  vpc_cidr                  = "10.0.0.0/16"
  public_subnet_cidr_list   = ["10.0.24.0/23", "10.0.26.0/23", "10.0.28.0/23"]
  private_subnet_cidr_list  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  database_subnet_cidr_list = ["10.0.36.0/24", "10.0.37.0/24", "10.0.38.0/24"]
  isolated_subnet_cidr_list = ["10.0.30.0/23", "10.0.32.0/23", "10.0.34.0/23"]
}


ecs_cluster_config = {
  enable = false
}

sns_subscriptions_email = [
  "scott.li@one2.cloud",
  "kc.wan@one2.cloud",
]


env_secrets = {
  UNIVERSE_DOMAIN               = "googleapis.com"
  REAP                          = "REAP"
  S3_REGION                     = "ap-southeast-1"
  UNIVERSE_DOMAIN               = "googleapis.com"
  SUMSUB_ENDPOINT               = "https://api.sumsub.com/resources"
  APP_NAME                      = "LOOKCARD"
  SUMSUB_ACCESS_TOKEN           = "prd:jt9sRICSq0h8pwz8lvX7iPSt.wwtl4htPblnWGPQ3cZKn8LB2ijaiEryK"
  TRANSACTION_MS_URL            = "https://api.test.lookcard.io/v2/api/tran-m13unmbb2/"
  SUMSUB_ACCESS_TOKEN_PROD      = "prd:jt9sRICSq0h8pwz8lvX7iPSt.wwtl4htPblnWGPQ3cZKn8LB2ijaiEryK"
  CLIENT_CERT_URL               = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zycoo%40lookcard-development.iam.gserviceaccount.com"
  USER_MS_URL                   = "https://api.test.lookcard.io/v2/api/us-f8zjng13d/"
  SUMSUB_PROD                   = "SUMSUB_PROD"
  REAP_API_KEY                  = "rj1s6dihlzpu77fibfyrxta34"
  AUTH_PROVIDER_CERT_URL        = "https://www.googleapis.com/oauth2/v1/certs"
  FILR_EXPIRES_DATE             = "01-01-2060"
  REPORTING_MS_URL              = "https://api.test.lookcard.io/v2/api/report-zjx14peaj/"
  ENVIRONMENT_STATUS            = "prod"
  PORT                          = 8000
  NOTIFICATION_MS_URL           = "https://api.test.lookcard.io/v2/api/notify-eh1gwoj67/"
  REAP_DEC_ARN                  = "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:REAP_RSA_PRIVATE_KEY-qd86xe"
  S3_AC                         = "public-read"
  EKYC_ENDPOINT                 = "cloudauth-intl.cn-hongkong.aliyuncs.com"
  SUMSUB_SECRET_KEY_PROD        = "8ZdygiTchu9WDfuJ1AADbOGXdmET85AQ"
  FROM_EMAIL                    = "no-reply@lookcard.io"
  SUNSUB_SECRET_KEY             = "8ZdygiTchu9WDfuJ1AADbOGXdmET85AQ"
  UTILITY_MS_URL                = "https://api.test.lookcard.io/v2/api/uti-lel6n01qq/"
  TOKEN_URI                     = "https://oauth2.googleapis.com/token"
  AUTH_MS_URL                   = "https://api.test.lookcard.io/v2/api/auth-zqg2muwph/"
  SEND_GRID_API_KEY             = "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"
  REAP_BASE_URL                 = "https://sandbox.api.caas.reap.global"
  S3_BUCKET_NAME                = "look-card-uat-new-upload"
  S3_BUCKET_NAME_ARN            = "arn:aws:s3:::look-card-uat-new-upload"
  S3_ACL                        = "public-read"
  AWS_ENCRYPTION_KEY_ID         = "dde924e0-2b6b-4056-9206-bbae2d6d3f6f"
  SUMSUB_TOKEN_EXPIRY           = "172800"
  ENCRYPTION_KEY                = "rGoAO+~d9$y#N&-TtvU3W)MrH"
  package_name                  = "SUMSUB_PROD"
  ACCOUNTSID                    = "AC37ab1711e86ca970ddf4df5487731570"
  AUTHTOKEN                     = "b58fece0b84b408ef8445c77c40e2fb5"
  VERIFYSID                     = "VA29aaaf84dff7320a92a3683daae938bf"
  TYPE                          = "service_account"
  PROJECT_ID                    = "lookcard-development"
  PRIVATE_KEY_ID                = "334b9f20f8630357be3d590ac8651ab82b2d3e02"
  PRIVATE_KEY                   = <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDdKKlR8j49rgHe
k7H3ehnn8kgDFkPXPpJD4bAmJkASrkakpz82PsMrKw/N3yejQNVx22K4abl5jTN1
yEEf1UFuBpmqka4WXXgPbJj9yfgTmkhb5tFpUlCsYSn+xXqqIesG6oeyy+9eLktd
rtVI0FDAPcJBc3E+CLoUnvIyG9BS+Af6Tm03jLp+SJrtWrmPgjlfky5ixAXDLm+4
3u8jGwcdxg3g220BNWmh8v2WmeVoU61HaWVHG1z5oWNhuHNWZ3wvnu/2kTTui+56
4a0HucBEse1znIhjAguaqBnDnO2W7LTqe+uJBAxAriQHCcg8WONmOi2N8o6DX9ry
0oCgqubrAgMBAAECggEASRke+fBtBRsGECjWGlu3w1Pv3GFYFAVg9+HZRIrBA8up
mtOSz52oCZUmmJ/JLKsJwaPHOffr75KtryD88YYdpb21vcx/83F6dPKqkLvYbLZC
c2nTzpGAC7Hj3Qsts50ZX0RWjNDeMc1waKsYYQRFpHzlP5fmFqBwzM8Kc2iBD2LB
fBmJtC1gNr/Q8Yq+stNWSxYh5F0uaQhocq182Do/mO4WcnVYKs4ypko8ea9dpvHS
7X7cD1dQwYWWY4lU46YuVxFX7LGa3uYZ0rewDee0fPW59JLHzNoHRkRRqjY3UhV+
nNqX0g3YN/IyQ+g3WrIVqKmfOrsrsFPUJ3yxQAz3nQKBgQD0FC+RJTPNj6IE9O2j
geMJLP4Zn0OL8x07ztLWBAN8h9YymRHA0GGKxnffOPegGK7CC55B9K0xpfkAqMCq
DzrA2LKwVFnGPb1kxt7RDEsZkzVPLdSBXUf9pcL78tgVgMVQ/hikPpk4ZQbdcev7
d8bMnf00b+Q3hxJat3wkg7zgpwKBgQDn9eXHsc2z1MM5ltXH3/3HnoTU0kMNqvLI
cEFqapRij61QzNJkmaaYdNpexR2tqADXpaPM6SxJm2Dc6NK4JdQvHRaa57sZJQDy
IYZAORo6pLh4+IXh596/oMQY4w8ad0Egx7IdmyzO7qt/i4Uus0+W9aDqPvWFwxQr
x/VCN2lsHQKBgDDlblYMduFCWfnWO1kbJylqawkk/7oknQGjQFeBfFVRPRbr1UOk
OzY65j7AwdK/vxq+ixi5dIzSrBx2sgoffOyvPLTYYRe2vJ9Yu8BzTwQzmmVfUAgO
cOKed35Tuvgr0NuV28fjhnxmuMZaESVSbHAHYndDxxtcos+rnGIQRiFXAoGAWeEM
Ag7BN/cvFjd96o6+VQT1T0mRtdARdt0YW9WkXXRyoaZbt6NZzCUrICGc2FcKzIRg
LdwDzxmntLF6RORTjVXmFmvIMXwHG8slq+j0YtjEqgsSRXCE/RecJFCG36hp0fvO
5m3kNOKCDU/QcUIFiubuTRXMKOJoBHbcb6Xs8XkCgYAXIK5NpniFEreiG5kX8DQ9
jA4W7jxwO0sbc+qQW3qjbumewkMLSvU3J+hTi9cmGr7bItXF52d2grh30rRnnpco
OrF12mBWut822ctWOg++/Uvtlp/DVw12sORfP4vedetJlz86ySEa/S38I3w8fdyw
fXa7Tu3CYKyWAP4DTqU30Q==
-----END PRIVATE KEY-----
EOF
  CLIENT_EMAIL                  = "firebase-adminsdk-zycoo@lookcard-development.iam.gserviceaccount.com"
  CLIENT_ID                     = "101053514353355045967"
  AUTH_URL                      = "https://accounts.google.com/o/oauth2/auth"
  AUTH_PROVIDER_X509_CERT_URL   = "https://www.googleapis.com/oauth2/v1/certs"
  CLIENT_X509_CERT_URL          = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zycoo%40lookcard-development.iam.gserviceaccount.com"
  BLOCKCHAIN_MS_URL             = "https://api.test.lookcard.io/v2/api/blc-s1umi0pnk/"
  SQS_URL                       = "https://sqs.ap-southeast-1.amazonaws.com/975050173595/"
  FIREBASE_AUTH_DOMAIN          = "lookcard-development.firebaseapp.com"
  FIREBASE_MEASUREMENT_ID       = "G-8QSEP19JXE"
  FIREBASE_MESSAGING_SENDING_ID = "630033385979"
  FIREBASE_PROJECT_ID           = "lookcard-development"
  FIREBASE_API_KEY              = "AIzaSyD96nflUgPQCm0o2SPzAIuUmCl9Pb4VN-4"
  FIREBASE_APP_ID               = "1:630033385979:web:09ee8edd1099d44316a35e"
  FIREBASE_STORAGE_BUCKET       = "lookcard-development.appspot.com"
  FIREBASE_DATABASE_URL         = "https://lookcard-development.firebaseio.com"
  FIREBASE_KEY                  = "AAAAkrDqifs:APA91bHuSFqXYoTuGTSwfAmzOWbiTJWgfVNzfQgW3pumioIEQRszfnf-D8VaZbSXRlRTVK36atauCwsfIMSYa-kZFdm3OvNs07mopT5sVd4yRrl9LqNCeTPYRqNESGFnyrEK85sRcEyd"
  CARD_MS_URL                   = "https://api.test.lookcard.io/v2/api/card-ywso44nnn/"
  CLIENT_URL                    = "https://test.lookcard.io/"
  SERVER_HOSTNAME               = "https://test.lookcard.io"
  AML_BASE_URL                  = "https://api.qa.aml-ai.net/v1/"
  AML_API_KEY                   = "52945c7k74cS873Md554_2beezbR996b5b26e383fmc1a"
  ADMIN_EMAIL                   = "admin@mailinator.com"
  KMS_GENERATOR_KEY_ID          = "arn:aws:kms:ap-southeast-1:975050173595:key/c6988d93-7c9a-4886-a97e-2fa12476f21e"
  KMS_ENCRYPTION_KEY_ID         = "arn:aws:kms:ap-southeast-1:975050173595:key/dde924e0-2b6b-4056-9206-bbae2d6d3f6f"
  SUMSUB_APPLICATION_LEVEL      = "basic-kyc-level_uat"
  EDNS_API_KEY                  = "a5205fdd-86a3-4675-8959-46f912a31284"
  EDNS_ENDPOINT                 = "https://api.dev.edns.domains/v2/public/lookcard/"
}

notification_env_secrets = {
  SEND_GRID_API_KEY = "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",
  FIREBASE_API_KEY  = "AIzaSyD96nflUgPQCm0o2SPzAIuUmCl9Pb4VN-4"
}

tron_secrets = {
  API_KEY = "a22c5f50-3dbb-4e32-a68d-852e7b6c362e"
}

coinranking_secrets = {
  API_KEY = "x"
}

crypto_api_worker_wallet_secrets = {
  VAULT_PRIVATE_KEY       = "8a19fe7297658e7122fe397941b5c477240528fae16a77a1394ac939e6e9190f"
  VAULT_ETHEREUM_ADDRESS  = "0xCD58F85e6Ec23733143599Fe0f982fC1d3f6C12c"
  VAULT_TRON_ADDRESS      = "TUgz79AB3mre5tFX7HVoZfKqWyYDfKBtTo"
  WORKER_PRIVATE_KEY      = "8a19fe7297658e7122fe397941b5c477240528fae16a77a1394ac939e6e9190f"
  WORKER_ETHEREUM_ADDRESS = "0xCD58F85e6Ec23733143599Fe0f982fC1d3f6C12c"
  WORKER_TRON_ADDRESS     = "TUgz79AB3mre5tFX7HVoZfKqWyYDfKBtTo"
}

elliptic_secrets = {
  API_KEY    = "96d937e0e9190f0ee2f1941e5daf6766"
  API_SECRET = "22a2218210a196c2be68a6ec480e8974"
  BASE_URL   = "https://aml-api.elliptic.co"
}

reap_secrets = {
  API_KEY  = "x"
  BASE_URL = "x"
}

token_secrets = {
  staticToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXNzd29yZCI6InFMeC1kPy03WlY2LE52JEtsUjNZQ2soLFp4SjVjd25IIiwiaWF0IjoxNzExNTEyMzgzLCJleHAiOjE3MTE1MTM1ODN9.6CLcPnCJLp1EJWPg9NNt_1kRum46TnNnb2mKtNlCwG4"
}

did_processor_lambda_secrets = {
  NODE_URL         = "https://polygon-mumbai-pokt.nodies.app"
  CHAIN_ID         = "31337"
  PRIVATE_KEY      = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
  REGISTRY_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
  ISSUER_ADDRESS   = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
  DDB_TABLE_NAME   = "did-temp-storage-table"
  DDB_ENDPOINT_URL = "https://dynamodb.ap-southeast-1.amazonaws.com"
}

aml_env_secrets = {
  TRON_PRO_API_KEY                 = "b745f773-a6c8-494e-9922-85f6246c8bf1"
  fund_wallet_private_key          = "08eae60b59582a8d3975af9b06ff8990d9bbc7a3fa002707bb256bc41591734d"
  elliptic_key                     = "96d937e0e9190f0ee2f1941e5daf6766"
  elliptic_secret                  = "22a2218210a196c2be68a6ec480e8974"
  fcm_api_key                      = "key=AAAAkrDqifs:APA91bHuSFqXYoTuGTSwfAmzOWbiTJWgfVNzfQgW3pumioIEQRszfnf-D8VaZbSXRlRTVK36atauCwsfIMSYa-kZFdm3OvNs07mopT5sVd4yRrl9LqNCeTPYRqNESGFnyrEK85sRcEyd"
  private_key                      = "072C5EB02F174A1127C94C2969DD736D7BD78A0EB90635D4A4FE58874DB1EEE0"
  tron_url                         = "https://nile.trongrid.io/v1/contracts"
  tron_usdt_contract_address       = "TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj"
  wallet_monitor_sqs               = "https://sqs.ap-southeast-1.amazonaws.com/576293270682/Eliptic"
  tron_usdc_contract_address       = "TEMVynQpntMqkPxP6wXTW2K7e4sM3cRmWz"
  tron_fullHost                    = "https://nile.trongrid.io"
  admin_waller_address             = "TEPbGowtz8vam34tNX7Kmaxv8FmsnbCRqE"
  gas_fees                         = "10000000"
  DATA_PROCESS_SQS                 = "https://sqs.ap-southeast-1.amazonaws.com/576293270682/Data-Process"
  TOKEN_API_URL                    = "https://api.test.lookcard.io/v2/api/auth-zqg2muwph/get-firebase-access-token-by-email"
  NOTIFICATION_SQS_URL             = "https://sqs.ap-southeast-1.amazonaws.com/975050173595/Notification"
  WEBSOCKET_SQS_URL                = "https://sqs.ap-southeast-1.amazonaws.com/975050173595/Push_Message_Web"
  TRANSACTION_REJECT_API_URL       = "https://api.test.lookcard.io/v2/api/blc-s1umi0pnk/transaction-rejected"
  API_GATWAY_WEBSOCKET_URL         = "https://ozllo33dx8.execute-api.ap-southeast-1.amazonaws.com/UAT/"
  tron_transaction_logs_url        = "https://nile.trongrid.io/wallet/gettransactionbyid"
  WITHDRAW_APPROVAL_API            = "https://api.test.lookcard.io/v2/api/blc-s1umi0pnk/withdrawal-approved"
  WITHDRAW_REJECT                  = "https://api.test.lookcard.io/v2/api/blc-s1umi0pnk/withdrawal-rejected"
  DATABASE_ARN                     = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:uat/db/secret-8KkFTx"
  ADMIN_SENDER_EMAIL               = "lookcard@roundesk.io"
  ADMIN_RECEIVER_EMAIL             = "lookcard@mailinator.com"
  KMS_ENCRYPTION_KEY               = "arn:aws:kms:ap-southeast-1:975050173595:key/dde924e0-2b6b-4056-9206-bbae2d6d3f6f"
  EXTERNAL_WALLET_FUND_CAPTURE_API = "https://api.test.lookcard.io/v2/api/blc-s1umi0pnk/blockchain-funds-added-externally"
}

aggregator_env_secrets = {
  WORKER_WALLET_PRIVATE_KEY = "1796ec1ad3059355b443fe07ea25de3652d6ed7ff8aa648393fa6a8e379a4999"
WORKER_WALLET_ADDRESS = "TF6htcmXxbwDd4uNgRjJsxsoPBqwfdwsP1"
}

firebase_secrets = {
  SERVICE_ACCOUNT_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1od959tGk1y8H\nTg640rkPXm7jFq2iXkU3C2LgpigJe1JM2Hl/k3VFdEoWsG1BFT6wxeyaza2mdDGy\n9FTHfAaWH1nyPTGJHrz1XGR5PUeF/S2TFLsNZxJ4EqNoVv0h5r2dy8RierHIjzE0\nWgPVmg9jr0Hm3WbKUg4PF9dcvNfToVvMkK6v3EtkSPOa5zq7ZznjAamXcXTTveCf\nQDGr7XxDpw8W/wBDtb30cMGaY3VvS9wB/Vkmith8GV201MCvgvzIfF3Wz2NCuS6V\nAh4fJH1K+dDnFZKZqBCCYdds2qhKjfXOErgagWccYqTHeO7m8ZUp4uOBe8Z/TZpe\nsBVcgeXXAgMBAAECggEARbQJ3bXlTWPRJfYEO1SO9YFxf4+f8exIlq+1ce4B9mWP\nt3Lp6ZYuzokqt5tcSjo7dT53pw7gobz8p6cRc/66TllYvNhUDsGvlV+wJUDplleL\namLtx95y3YaVlECx4xU4Vnqw8nQQjx24rdUPnKUDW+eRnGYCAQnNYGhvWyUTlKC1\nyKp/te8VRTuKSlGOn3AXOQBoxixgDMiAmqaCrHaRw7SU9eeCYskt1lHH99JAFgyw\nnm+dkMnDn5eEy0WEupqdvFaIhJ1hdh6BB8GZmzTn0pQRjyE3acwjibf2A39huZDA\nIGUpVsRg6UqGV+1VSlKaOwR4puAM5BKgdd+KLVON/QKBgQDf8+SAjydIPmBT3acV\nmJXmqP1lIuIfd5dWKvZkL/KY2WiDrQX45jp7AMH7fvZgVPjmhrwhuDh1zM+sEwc7\nQK83EXQ8I2SVa4rFxKsaY5bEjYWcNQtT0EsApvZLie9ljMqU7xVJZHoE0rgU2MgP\nJgVvria+eyUZp9D+7BmXoZbQcwKBgQDPn6YDXM84bjR7DnvB4iE0wsGdQ4rwZUUo\n2p+/nwNCDdK0U9WX+0GShincu7+8D7cLalM86cVn7aBCjxDRXrstVGrkZeG93sEu\nFcSEyRny0zoyJhW4qVC2NFDlazvIRsd9GF1QTDlQWJV12uBQmoECfNelVEJ+Pgbr\npAQHaf1wDQKBgF97twLxBgiRP7TCHkjg45iSmGcUdmCANq/wZVjV8JMmrp7lmFRE\npM5oxkwaF6V+1RhEfdXKm5fuGOT+v+iNbacG9A3n8Syby3ECpwj7SP7IcBznqMq1\nViUTCpOuXbloS78wKF1AT53a0c1hl/qNdWfmUnKIQosrt7nYpBi4NnrtAoGBAJKe\nsnUDcI7wPH1+T+UuVLbWpjXxwcdcLMfaBCAlIf7eliKkZV0roTXhKuTnbVJYYrJc\nBqYojDCFfbwjHgRM+q/bQpVCYXVdPlzWIG6JOZrikeFiRcqfPxE8xrgMzy3y1ePA\ndf1DpuHXfMy6odgqE9r24K6vXzmZgfecXwABWGltAoGBAK+7fzdN17l0Qi0tmSX7\nYYm58HyTun2LBcTjaSFz3Ze1IgiDaGG+5pW2jtFBOj4nYZGCrFq1xn9SbtAGq1wR\nOWA2SOh9LtF46O3EfPRxDyGWLUBCcpScK2i1vVfmy9Fu74cE8w+fYfHonMiBHE7s\nJ/PFXb0aRPjQjNMwS5YHM9Q3\n-----END PRIVATE KEY-----\n",
  PROJECT_ID = "lookcard-development",
  SERVICE_ACCOUNT_CLIENT_EMAIL = "firebase-adminsdk-zycoo@lookcard-development.iam.gserviceaccount.com",
  CREDENTIALS = "{   \"type\": \"service_account\",   \"project_id\": \"lookcard-development\",   \"private_key_id\": \"fcd62d5c65803ed835dc80a8d5fca0577e3cca6a\",   \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDKhfgXSsSNl/5G\\nvfRuMCDO7KcZFkW1TxcSHMoIjZh/cJagonezQaiWZnyT9HnkfUHAJogsYe6e+coW\\nGrbOETV8PHiCrG3x4eEECyAvTlnks/mDIZli421pUawBjpFewrrE3gXtpoHMoRNQ\\nQ4EDSRGJeUSgAvLHEYKfx6skPNrEYqX0/4hxdW7gzj0woDYpYkCEw0Un7OUZlT3A\\nQFOx7XUZGpX3SmD1DoXhj79kP/GX4Z59JVsguiZJB+g9UWZ5X+KjfVQf7S+MYCCT\\nT0/SdGt0JQcQjhWppMNwqSknQ1sWzsYdNoIhwDLKXbXjb5W3SYfFo1EubzMgL3yi\\nOlrmfC/BAgMBAAECggEAMQsRQZ63C2zvxDTS4O4hu8peSrp0hgwRk67KFBkqAU6E\\nA4FkiFHRoB5Qc8njzLuydPQ/zLOog/IMiJ7Ofwd20s+YBVj5RPaEtaR2Fk6cgUA+\\nH42+5c4aXENNapEaTf7NGMiFWgAU9bdaBHlcYC3NI+PshO1B2og4gDXrkVp1RdII\\n9qd7uHObq+3Ye7Emva5usDZ9BsXhSx8TQ0YG34LNARBCHdPeCd3QaV7TiDn7eLxt\\n+fIoDVP1NKy4Fe/ij3cwwDp6R2oCxtIhKBpEJMp2U4ccZN2ZJPrG5z0ODtjKWP0o\\nre5M/2Hx7pRWcnMfINeqPWHWXuCSlEcFL3zz7mDFAwKBgQD7nGClC+tOLBQnoh+D\\ncCE14wZXIaR+VYkMIiCtzIjhqTX4FoNbMWqK+Fm/GAFclgMtvPEpA9MFkMd/5dFi\\natUMH0I0KTVpS43G5ps2I33YfipUe8QExbOkXPN1sDU0nR1LcZlylnmK1uX/dw82\\nudXJTYnG+iNaN0PesSrRWyoouwKBgQDODmFw4PktNOA1zyCsjGBFu1eohZYwobMh\\nfVNWBma4loNvbcAtYIlqqychX2hGvxLo4peTfkp5sZlUxd2lTN3kBOSFEFIJMp7I\\nAP63X/ZKNlM5LMmle9xY3U1U4IcBXt44/kyP9Nn2mm5AaFWqy9JdUnU2u7aVen0u\\nAOYPEVBPswKBgByiBRWDL7nrpjeEaZWpkv3w4e3UdEW0Mi5hS9q7ZfBYMz4SQcyE\\n6Rz7eisW7kC9CYuQ7ti+CKufeDSD0Lokci44+G27KsrawD2cTJlynIWgheyrUPlC\\nDllsAoCoFsXwAz9spAu4OAimv/G8eMy/hSatXjp4iMFhfKXA/6BngXq1AoGBAMMt\\ncfTW1I+SfzHY4S0vxl0myDBTYODtuVxmdpKMe64qu5LHlXol7+P+/JCq633frUy0\\nnTjTLj45EHDw/zJ9Lcy3KbI0tFAMB8SQ1LTji8ndzVTh7Jr4SM5PyNk12AtfTgUU\\nM3dESVVCEF6ntUWTzM4ite5DPf42yO3TYhcxoi3rAoGAXkYbcXwNOW7EEO2UJeGQ\\nn1paQnxBeiCCIUwnZwKrMI1UhhE3pedhkUjYUGCQmNT2xzMj9nC+hlcUruk8LhL4\\nei4/8WHkkuMSsPx9lokvDWfz3W382pcQQH5Q6Qe3llIVArEHhDJFnOTh6LGkcYBz\\nefb+mV51tjFVI1Y4eXOYZNw=\\n-----END PRIVATE KEY-----\\n\",   \"client_email\": \"firebase-adminsdk-zycoo@lookcard-development.iam.gserviceaccount.com\",   \"client_id\": \"101053514353355045967\",   \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",   \"token_uri\": \"https://oauth2.googleapis.com/token\",   \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",   \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zycoo%40lookcard-development.iam.gserviceaccount.com\",   \"universe_domain\": \"googleapis.com\" }"
  }


db_secrets = {
  username = "lookcarduat"
password = "Us676VboS6a2t9T4"
engine = "postgres"
host = "lookcard-database-instance-0.c2ifylljo98k.ap-southeast-1.rds.amazonaws.com"
port = "5443"
dbname = "lookcard"
}

crypto_api_env_secrets = {
  DATABASE_URL = "postgresql://lookcardtest:s<C|}`?wu|*4i:;v@lookcard-testing-db.cluster-c2ifylljo98k.ap-southeast-1.rds.amazonaws.com:5443/main?sslmode=require"
}

secret_arns = [
  "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:crypto-api-env-a24Wh1",
  "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:firebase-JujygD",
  "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:db/secret-zkQPXo",
  "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:elliptic-ImZyZj"
]

