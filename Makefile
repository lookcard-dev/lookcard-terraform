# Terraform backend configuration
BUCKET_NAME=lookcard-terraform-backend-development
TABLE_NAME=lookcard-tf-lockid
REGION=ap-southeast-1

plan:
	@terraform plan -var-file="terraform.develop.tfvars.json"

apply:
	@terraform apply -var-file="terraform.develop.tfvars.json"

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  terraform-init              - Initialize S3 bucket and DynamoDB table for Terraform backend"
	@echo "  terraform-backend-s3-init   - Create S3 bucket for Terraform state"
	@echo "  terraform-backend-ddb-init  - Create DynamoDB table for state locking"
	@echo "  download-config-file        - Download Terraform config file from S3"
	@echo "  terraform-apply-dev         - Apply Terraform changes to dev environment"
	@echo "  terraform-apply-prod        - Apply Terraform changes to prod environment"
	@echo "  terraform-apply-module      - Apply changes to specific module (set MODULE=<name>)"

init:
	

terraform-backend-s3-init:
	@echo "Initializing S3 backend..."
	@aws s3api create-bucket \
		--bucket $(BUCKET_NAME) \
		--region $(REGION) \
		--create-bucket-configuration LocationConstraint=$(REGION)
	@aws s3api put-bucket-versioning \
		--bucket $(BUCKET_NAME) \
		--versioning-configuration Status=Enabled
	@aws s3api put-bucket-encryption \
		--bucket $(BUCKET_NAME) \
		--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

terraform-backend-ddb-init:
	@echo "Initializing DynamoDB backend..."
	@aws dynamodb create-table \
		--table-name $(TABLE_NAME) \
		--attribute-definitions AttributeName=LockID,AttributeType=S \
		--key-schema AttributeName=LockID,KeyType=HASH \
		--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
		--table-class STANDARD \
		--region $(REGION)

terraform-init: terraform-backend-s3-init terraform-backend-ddb-init

download-config-file:
	@echo "Downloading config file..."
	@aws s3 cp s3://$(BUCKET_NAME)/terraform.tfvars.json ./terraform.tfvars.dev.json

terraform-apply-dev: 
	@echo "Applying development environment..."
	@terraform init -reconfigure
	@terraform apply -var-file="terraform.tfvars.dev.json" 
	@aws s3 cp ./terraform.tfvars.dev.json s3://$(BUCKET_NAME)/terraform.tfvars.dev.json

terraform-unlock:
	@terraform force-unlock ${TF_LOCK_ID}

terraform-apply-module:
	@if [ -z "$(MODULE)" ]; then \
		echo "Error: MODULE variable is not set. Usage: make terraform-apply-module MODULE=<module_name>"; \
		exit 1; \
	fi
	@echo "Applying module $(MODULE)..."
	@terraform apply -var-file="terraform.tfvars.dev.json" -target=module.$(MODULE) 

terraform-apply-prod: download-config-file
	@echo "Applying production environment..."
	@terraform init -reconfigure
	@terraform plan -var-file="terraform.tfvars.prod.json"
	@terraform apply -var-file="terraform.tfvars.prod.json" -auto-approve