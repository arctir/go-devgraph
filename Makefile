# Makefile for generating oapi-codegen server code
DEVGRAPH_API_SPEC=../devgraph/specs/devgraph/v1/spec.yaml

.PHONY: generate

generate:
	mkdir pkg/apis/devgraph/v1 -p
	@echo "Generating code for OpenAPI specification..."
	oapi-codegen -config config.yaml ${DEVGRAPH_API_SPEC}
