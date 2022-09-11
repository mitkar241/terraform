init:
	terraform init

fmt:
	terraform fmt

console:
	terraform console -var 'aws_env=dev'

plan:
	terraform plan -var 'aws_env=dev'

apply:
	terraform apply -auto-approve -var 'aws_env=dev'

destroy:
	terraform destroy -auto-approve -var 'aws_env=dev'

refresh:
	terraform apply -auto-approve -refresh-only

list:
	terraform state list

output:
	terraform output
