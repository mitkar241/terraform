init:
	terraform init

fmt:
	terraform fmt

clean:
	rm -rf .terraform* terraform.tfstate*

console:
	terraform console -var-file=../../envs/stag/devsetup.tfvars -lock-timeout=300s

plan:
	terraform plan -var-file=../../envs/stag/devsetup.tfvars -lock-timeout=300s

apply:
	terraform apply -auto-approve -var-file=../../envs/stag/devsetup.tfvars -lock-timeout=300s

destroy:
	terraform destroy -auto-approve -var-file=../../envs/stag/devsetup.tfvars -lock-timeout=300s

refresh:
	terraform apply -auto-approve -refresh-only

list:
	terraform state list

output:
	terraform output
