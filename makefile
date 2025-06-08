CLUSPAR_IP := $(shell terraform -chdir=terraform output -json | jq -r '.cluspar_ips.value.public_ip')

.PHONY: init build terraform ansible

init:
	@echo Initing terraform
	cd terraform && terraform init -upgrade
	@echo Installing Ansible Galaxy packages
	ansible-galaxy collection install prometheus.prometheus

terraform:
	terraform -chdir=terraform apply 

ansible:
	cd ansible && ansible-playbook setup-machines.yaml

push2machine:
	scp -r ClusPar ubuntu@$(CLUSPAR_IP):/home/ubuntu/


build:
	cd ClusPar && mvn clean build