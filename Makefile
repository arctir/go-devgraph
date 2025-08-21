# Makefile for generating oapi-codegen server code
DEVGRAPH_API_SPEC=../devgraph/specs/devgraph/v1/spec.yaml

.PHONY: generate

generate:
	go install -v github.com/ogen-go/ogen/cmd/ogen@latest
	mkdir pkg/apis/devgraph/v1 -p
	@echo "Generating code for OpenAPI specification..."
	ogen -config ogen.yaml -target pkg/apis/devgraph/v1 ${DEVGRAPH_API_SPEC}
