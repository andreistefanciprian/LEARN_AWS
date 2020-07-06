TF_TARGET=
TF_PLAN_FILE=$(TIMESTAMP)-tf.tfplan
TF_EXEC=docker-compose run terraform
TF_EXTRA_OPS=
TIMESTAMP=date +%Y%m%dT%H%M%S

all: plan

clean:
	@rm -rf .terraform

get:
	$(TF_EXEC) get .
	$(TF_EXEC) fmt

init: clean get
	$(TF_EXEC) init -input=false

plan: init
	$(TF_EXEC) plan -input=false -out=$(TF_PLAN_FILE)

deploy: plan
	$(TF_EXEC) apply $(TF_PLAN_FILE) && rm $(TF_PLAN_FILE)

deploy-auto-approve: init
	$(TF_EXEC) apply -input=false -auto-approve

destroy: init
	$(TF_EXEC) destroy $(TF_EXTRA_OPS)

destroy-auto-approve: init
	$(TF_EXEC) destroy -input=false -auto-approve