#account := acc
.PHONY: init plan apply destroy 

VARS_ENV="environments/${WORKSPACE}.tfvars"

lint:
	@terraform fmt -diff -recursive -list=false -write=true

validate:
	@terraform validate

create: check-env
	@terraform init --backend-config=backend.tfvars
	@terraform workspace new ${WORKSPACE}

workspace: check-env
	@terraform init --backend-config=backend.tfvars
	@terraform workspace select ${WORKSPACE}

state: check-env
	@terraform state list

plan: check-env
	@terraform plan \
        -var-file=${VARS_ENV} \
        -out tfplan

plan-scan:
	@terraform show -json tfplan > tf.json
	@checkov -f ./tf.json
	
apply: 
	@terraform apply tfplan

destroy: check-env
	@\
        terraform destroy \
        -var-file=${VARS_ENV} \
        --auto-approve

list: state

all : workspace plan 

check-env:
ifndef WORKSPACE
        $(error workspace is undefined)
endif