terraform-backend-s3-init:
	aws s3api create-bucket --bucket lookcard-testing-tf --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1

terraform-backend-ddb-init:
	aws dynamodb create-table --table-name lookcard-tf-lockid --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --table-class STANDARD --region ap-southeast-1

terraform-init: terraform-backend-s3-init terraform-backend-ddb-init