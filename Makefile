# Variables
CHARTS_DIR := helm-charts
RELEASE_DIR := releases

# Helm binary
HELM := helm

# Default target
.PHONY: all
all: clean package

# Clean the release directory
.PHONY: clean
clean:
	@echo "Cleaning release directory..."
	@rm -rf $(RELEASE_DIR)
	@mkdir -p $(RELEASE_DIR)

# Package all charts
.PHONY: package
package:
	@echo "Packaging Helm charts..."
	@mkdir -p $(RELEASE_DIR)
	@for chart in $(CHARTS_DIR)/*; do \
		if [ -d "$$chart" ]; then \
			$(HELM) package $$chart --destination $(RELEASE_DIR); \
		fi \
	done
	@echo "Charts packaged into $(RELEASE_DIR)."

# Generate Helm repository index
.PHONY: index
index: package
	@echo "Generating Helm repository index..."
	@$(HELM) repo index $(RELEASE_DIR) --url https://meshkat632.github.io/apple-be/release
	@echo "Index generated in $(RELEASE_DIR)."

# Publish charts to GitHub Pages (optional)
.PHONY: publish
publish: index
	@echo "Publishing Helm charts to GitHub repository..."
	@git add $(RELEASE_DIR)
	@git commit -m "Update Helm charts and index"
	@git push origin main
	@echo "Charts published."

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all     - Clean, package, and generate index for Helm charts"
	@echo "  clean   - Clean the release directory"
	@echo "  package - Package Helm charts into the release directory"
	@echo "  index   - Generate Helm repository index"
	@echo "  publish - Publish charts to GitHub Pages"
	@echo "  help    -
