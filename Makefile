BUCKET_NAME=lookcard-terraform-backend-development
TABLE_NAME=lookcard-tf-lockid
REGION=ap-southeast-1

terraform-backend-s3-init:
	@echo "Initializing S3 backend..."
	@aws s3api create-bucket --bucket $(BUCKET_NAME) --region $(REGION) --create-bucket-configuration LocationConstraint=$(REGION)

terraform-backend-ddb-init:
	@echo "Initializing DynamoDB backend..."
	@aws dynamodb create-table --table-name $(TABLE_NAME) --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --table-class STANDARD --region $(REGION)

terraform-init: terraform-backend-s3-init terraform-backend-ddb-init

download-config-file:
	@echo "Downloading config file..."
	@aws s3 cp s3://$(BUCKET_NAME)/terraform.tfvars.json ./terraform.tfvars.dev.json

terraform-apply-dev: 
	@echo "Applying development environment..."
	@terraform init -reconfigure
	@terraform apply -var-file="terraform.tfvars.dev.json" 
	@aws s3 cp ./terraform.tfvars.dev.json s3://$(BUCKET_NAME)/terraform.tfvars.dev.json; 

terraform-apply-prod: download-config-file
	@echo "Applying production environment..."
	@terraform init -reconfigure
	@terraform apply -var-file="terraform.tfvars.prod.json"