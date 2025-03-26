BRANCH_NAME := $(shell git branch --show-current)

init:
	@terraform init -backend-config="profile=lookcard-terraform" -backend-config="key=$(BRANCH_NAME)/terraform.tfstate"

plan:
	@terraform plan -var-file="terraform.$(BRANCH_NAME).tfvars.json"

apply:
	@terraform apply -var-file="terraform.$(BRANCH_NAME).tfvars.json"

refresh:
	@terraform refresh -var-file="terraform.$(BRANCH_NAME).tfvars.json"

#https://www.infracost.io/docs/#quick-start
cost:
	@infracost breakdown --path . --terraform-var-file "terraform.$(BRANCH_NAME).tfvars.json"

compose:
	@docker compose up -d

visualize:
	@terraform plan -out plan.out -var-file="terraform.$(BRANCH_NAME).tfvars.json"
	@terraform show -json plan.out > plan.json
	@docker run --rm -it -p 9000:9000 -v $(pwd)/plan.json:/src/plan.json im2nguyen/rover:latest -planJSONPath=plan.json
