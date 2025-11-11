# Makefile for go-devgraph client generation

.PHONY: generate install clean

# Install ogen generator
install:
	go install github.com/ogen-go/ogen/cmd/ogen@latest

# Generate client from local spec file
# Usage: make generate SPEC=path/to/spec.yaml
generate: install
	@if [ -z "$(SPEC)" ]; then \
		echo "Error: SPEC variable is required"; \
		echo "Usage: make generate SPEC=path/to/spec.yaml"; \
		exit 1; \
	fi
	@echo "Generating Go client from $(SPEC)..."
	mkdir -p pkg/apis/devgraph/v1
	ogen --config .ogen.yaml --target pkg/apis/devgraph/v1 --clean $(SPEC)
	go mod tidy
	@echo "✓ Client generated successfully"

# Clean generated code
clean:
	rm -rf pkg/apis/devgraph/v1/*_gen.go
	@echo "✓ Generated code removed"
