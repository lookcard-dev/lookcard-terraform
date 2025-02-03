init:
	@terraform init -backend-config="profile=lookcard-terraform" -backend-config="key=develop/terraform.tfstate"

plan:
	@terraform plan -var-file="terraform.develop.tfvars.json"

apply:
	@terraform apply -var-file="terraform.develop.tfvars.json"

refresh:
	@terraform refresh -var-file="terraform.develop.tfvars.json"