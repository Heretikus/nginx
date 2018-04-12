KITCHEN_LOCAL_YAML=.kitchen.docker.yml

role-under-test:
	$(eval ROLE_UNDER_TEST := sa-nginx)
	@echo $(ROLE_UNDER_TEST)

test-docker: role-under-test
	echo "hello"

kitchen-destroy:
	KITCHEN_LOCAL_YAML=$(KITCHEN_LOCAL_YAML) kitchen destroy

kitchen-list:
	KITCHEN_LOCAL_YAML=$(KITCHEN_LOCAL_YAML) kitchen list

kitchen-create:
	KITCHEN_LOCAL_YAML=$(KITCHEN_LOCAL_YAML) kitchen create

kitchen-converge: role-under-test
	KITCHEN_LOCAL_YAML=$(KITCHEN_LOCAL_YAML) kitchen converge

kitchen-verify:
	KITCHEN_LOCAL_YAML=$(KITCHEN_LOCAL_YAML) kitchen verify
