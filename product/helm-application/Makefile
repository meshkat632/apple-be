# Default values
RELEASE_NAME ?= my-helm-application
NAMESPACE ?= debug
VALUES ?= -f values.yaml #-f values.secret.sops.yaml

.PHONY: helm-deploy helm-undeploy template

helm-deploy:
	helm upgrade --install $(RELEASE_NAME) . \
		--namespace $(NAMESPACE) --create-namespace $(VALUES)


helm-undeploy:
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

template:
	helm template $(RELEASE_NAME) . \
		--namespace $(NAMESPACE) $(VALUES)
