BRANCH_NAME := $(shell git branch --show-current)

# Terragrunt commands
init:
	@cd environments/$(BRANCH_NAME) && terragrunt run-all init

plan:
	@cd environments/$(BRANCH_NAME) && terragrunt run-all plan

apply:
	@cd environments/$(BRANCH_NAME) && terragrunt run-all apply

refresh:
	@cd environments/$(BRANCH_NAME) && terragrunt run-all refresh

# Module-specific commands
plan-module:
	@cd environments/$(BRANCH_NAME)/modules/$(MODULE) && terragrunt plan

apply-module:
	@cd environments/$(BRANCH_NAME)/modules/$(MODULE) && terragrunt apply

# Cost estimation
cost:
	@cd environments/$(BRANCH_NAME) && terragrunt run-all infracost breakdown --terragrunt-non-interactive

compose:
	@docker compose up -d

visualize:
	docker run --rm -it -p 9000:9000 -v $(CURDIR):/src im2nguyen/rover:latest -terragrunt-config environments/$(BRANCH_NAME)/terragrunt.hcl

# Setup scripts
setup:
	@./scripts/extract_image_tags.sh
	@./scripts/generate_environments.sh