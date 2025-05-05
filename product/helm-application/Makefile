# Default values
RELEASE_NAME ?= my-helm-application
NAMESPACE ?= debug
äVALUES ?= -f values.yaml -f secrets://values.secret.sops.yaml #-f values.secret.sops.unenc.yaml
VALUES ?= -f values.yaml -f values.secret.sops.yaml #-f values.secret.sops.unenc.yaml
#VALUES ?= -f values.yaml -f secrets+age-import://./key.txt?values.secret.sops.yaml

.PHONY: helm-deploy helm-undeploy template

helm-deploy:
	helm upgrade --install $(RELEASE_NAME) . \
		--namespace $(NAMESPACE) --create-namespace $(VALUES)


helm-undeploy:
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

template:
	HELM_SECRETS_WRAPPER_ENABLED=true helm secrets --debug template my-helm-application . --namespace debug $(VALUES)

