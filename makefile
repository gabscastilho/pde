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
	scp -r ClusPar ubuntu@$(CLUSPAR_IP):/home/ubuntu/ClusPar
	scp -r scripts ubuntu@$(CLUSPAR_IP):/home/ubuntu/scripts
	scp -r neo4j ubuntu@$(CLUSPAR_IP):/home/ubuntu/neo4j	

pull-results:
	scp ubuntu@$(CLUSPAR_IP):/home/ubuntu/ClusPar/output.txt.txt results/output.txt
	scp ubuntu@$(CLUSPAR_IP):/home/ubuntu/ClusPar/graph_visualization/partition_visualization.png results/output.png


build:
	cd ClusPar && mvn clean build