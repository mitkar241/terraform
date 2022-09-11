init:
	terraform init

fmt:
	terraform fmt

console:
	terraform console -var-file="dev.tfvars"

plan:
	terraform plan -var-file="dev.tfvars"

apply:
	terraform apply -auto-approve -var-file="dev.tfvars"

destroy:
	terraform destroy -auto-approve -var-file="dev.tfvars"

refresh:
	terraform apply -auto-approve -refresh-only

list:
	terraform state list

output:
	terraform output