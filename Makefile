ifeq ($(OS),Windows_NT)
    # Windows
    SHELL := powershell.exe
    .SHELLFLAGS := -NoProfile -Command
    LOAD_ENV_CMD := .\load-env.ps1;
else
    # Unix-like (Linux, macOS, WSL)
    SHELL := /bin/bash
    LOAD_ENV_CMD := source ./load-env.sh 2>/dev/null || true;
endif

BRANCH_NAME := $(shell git branch --show-current)

fmt:
	@terraform fmt -recursive

init:
	@terraform init -backend-config="profile=lookcard-terraform" -backend-config="key=$(BRANCH_NAME)/terraform.tfstate"

plan:
	@$(LOAD_ENV_CMD) terraform plan -var-file="terraform.$(BRANCH_NAME).tfvars.json"

apply:
	@$(LOAD_ENV_CMD) terraform apply -var-file="terraform.$(BRANCH_NAME).tfvars.json"

refresh:
	@$(LOAD_ENV_CMD) terraform refresh -var-file="terraform.$(BRANCH_NAME).tfvars.json"

#https://www.infracost.io/docs/#quick-start
cost:
	@infracost breakdown --path . --terraform-var-file "terraform.$(BRANCH_NAME).tfvars.json"

load-env:
ifeq ($(OS),Windows_NT)
	.\load-env.ps1
else
	@chmod +x load-env.sh 2>/dev/null || true
	@./load-env.sh
endif

help:
	@echo "Available commands:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Show Terraform plan"
	@echo "  apply    - Apply Terraform changes"
	@echo "  refresh  - Refresh Terraform state"
	@echo "  fmt      - Format Terraform files"
	@echo "  cost     - Show cost breakdown with infracost"
	@echo "  load-env - Manually load .env file"
	@echo ""
	@echo "Environment setup:"
	@echo "  1. Copy env.example to .env"
	@echo "  2. Edit .env with your values"
	@echo "  3. Run make commands (they auto-load .env)"

.PHONY: fmt init plan apply refresh cost load-env help