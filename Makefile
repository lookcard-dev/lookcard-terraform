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
	docker run --rm -it -p 9000:9000 -v $(CURDIR):/src im2nguyen/rover:latest -tfVarsFile "terraform.$(BRANCH_NAME).tfvars.json"