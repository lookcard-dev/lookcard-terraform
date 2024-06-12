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
  UNIVERSE_DOMAIN   = "googleapis.com"
  REAP              = "REAP"
  S3_REGION         = "ap-southeast-1"
  UNIVERSE_DOMAIN   = "googleapis.com"
  SUMSUB_ENDPOINT   = "https://api.sumsub.com/resources"
  APP_NAME          = "LOOKCARD"
  SUMSUB_ACCESS_TOKEN = "prd:jt9sRICSq0h8pwz8lvX7iPSt.wwtl4htPblnWGPQ3cZKn8LB2ijaiEryK"
  TRANSACTION_MS_URL  = "https://api.uat.lookcard.io/v2/api/tran-m13unmbb2/"
  SUMSUB_ACCESS_TOKEN_PROD = "prd:jt9sRICSq0h8pwz8lvX7iPSt.wwtl4htPblnWGPQ3cZKn8LB2ijaiEryK"
  CLIENT_CERT_URL = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zycoo%40lookcard-development.iam.gserviceaccount.com"
  USER_MS_URL = "https://api.uat.lookcard.io/v2/api/us-f8zjng13d/"
  SUMSUB_PROD = "SUMSUB_PROD"
  REAP_API_KEY = "rj1s6dihlzpu77fibfyrxta34"
  AUTH_PROVIDER_CERT_URL = "https://www.googleapis.com/oauth2/v1/certs"
  FILR_EXPIRES_DATE = "01-01-2060"
  REPORTING_MS_URL = "https://api.uat.lookcard.io/v2/api/report-zjx14peaj/"
  ENVIRONMENT_STATUS = "prod"
  PORT = 8000
  NOTIFICATION_MS_URL = "https://api.uat.lookcard.io/v2/api/notify-eh1gwoj67/"
  REAP_DEC_ARN = "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:REAP_RSA_PRIVATE_KEY-qd86xe"
  S3_AC = "public-read"
  EKYC_ENDPOINT = "cloudauth-intl.cn-hongkong.aliyuncs.com"
  SUMSUB_SECRET_KEY_PROD = "8ZdygiTchu9WDfuJ1AADbOGXdmET85AQ"
  FROM_EMAIL = "no-reply@lookcard.io"
  SUNSUB_SECRET_KEY = "8ZdygiTchu9WDfuJ1AADbOGXdmET85AQ"
  UTILITY_MS_URL = "https://api.uat.lookcard.io/v2/api/uti-lel6n01qq/"
  TOKEN_URI = "https://oauth2.googleapis.com/token"
  AUTH_MS_URL = "https://api.uat.lookcard.io/v2/api/auth-zqg2muwph/"
  SEND_GRID_API_KEY = "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"
  REAP_BASE_URL = "https://sandbox.api.caas.reap.global"
  S3_BUCKET_NAME = "look-card-uat-new-upload"
  S3_BUCKET_NAME_ARN = "arn:aws:s3:::look-card-uat-new-upload"
  S3_ACL = "public-read"
  AWS_ENCRYPTION_KEY_ID = "dde924e0-2b6b-4056-9206-bbae2d6d3f6f"
  SUMSUB_TOKEN_EXPIRY = "172800"
  ENCRYPTION_KEY = "rGoAO+~d9$y#N&-TtvU3W)MrH"
  package_name = "SUMSUB_PROD"
  ACCOUNTSID = "AC37ab1711e86ca970ddf4df5487731570"
  AUTHTOKEN = "b58fece0b84b408ef8445c77c40e2fb5"
  VERIFYSID = "VA29aaaf84dff7320a92a3683daae938bf"
  TYPE = "service_account"
  PROJECT_ID = "lookcard-development"
  PRIVATE_KEY_ID = "334b9f20f8630357be3d590ac8651ab82b2d3e02"
  PRIVATE_KEY = <<EOF
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
  CLIENT_EMAIL = "firebase-adminsdk-zycoo@lookcard-development.iam.gserviceaccount.com"
  CLIENT_ID = "101053514353355045967"
  AUTH_URL = "https://accounts.google.com/o/oauth2/auth"
  AUTH_PROVIDER_X509_CERT_URL = "https://www.googleapis.com/oauth2/v1/certs"
  CLIENT_X509_CERT_URL = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zycoo%40lookcard-development.iam.gserviceaccount.com"
  BLOCKCHAIN_MS_URL = "https://api.uat.lookcard.io/v2/api/blc-s1umi0pnk/"
  SQS_URL = "https://sqs.ap-southeast-1.amazonaws.com/975050173595/"
  FIREBASE_AUTH_DOMAIN = "lookcard-development.firebaseapp.com"
  FIREBASE_MEASUREMENT_ID = "G-8QSEP19JXE"
  FIREBASE_MESSAGING_SENDING_ID = "630033385979"
  FIREBASE_PROJECT_ID = "lookcard-development"
  FIREBASE_API_KEY = "AIzaSyD96nflUgPQCm0o2SPzAIuUmCl9Pb4VN-4"
  FIREBASE_APP_ID = "1:630033385979:web:09ee8edd1099d44316a35e"
  FIREBASE_STORAGE_BUCKET = "lookcard-development.appspot.com"
  FIREBASE_DATABASE_URL = "https://lookcard-development.firebaseio.com"
  FIREBASE_KEY = "AAAAkrDqifs:APA91bHuSFqXYoTuGTSwfAmzOWbiTJWgfVNzfQgW3pumioIEQRszfnf-D8VaZbSXRlRTVK36atauCwsfIMSYa-kZFdm3OvNs07mopT5sVd4yRrl9LqNCeTPYRqNESGFnyrEK85sRcEyd"
  CARD_MS_URL = "https://api.uat.lookcard.io/v2/api/card-ywso44nnn/"
  CLIENT_URL = "https://uat.lookcard.io/"
  SERVER_HOSTNAME = "https://uat.lookcard.io"
  AML_BASE_URL = "https://api.qa.aml-ai.net/v1/"
  AML_API_KEY = "52945c7k74cS873Md554_2beezbR996b5b26e383fmc1a"
  ADMIN_EMAIL = "admin@mailinator.com"
  KMS_GENERATOR_KEY_ID = "arn:aws:kms:ap-southeast-1:975050173595:key/c6988d93-7c9a-4886-a97e-2fa12476f21e"
  KMS_ENCRYPTION_KEY_ID = "arn:aws:kms:ap-southeast-1:975050173595:key/dde924e0-2b6b-4056-9206-bbae2d6d3f6f"
  SUMSUB_APPLICATION_LEVEL = "basic-kyc-level_uat"
  EDNS_API_KEY = "a5205fdd-86a3-4675-8959-46f912a31284"
  EDNS_ENDPOINT = "https://api.dev.edns.domains/v2/public/lookcard/"
}
