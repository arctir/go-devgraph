# Makefile for generating oapi-codegen server code
DEVGRAPH_API_SPEC=../devgraph/specs/system/v1/spec.yaml

.PHONY: generate

generate:
	mkdir pkg/apis/devgraph/v1 -p
	@echo "Generating code for OpenAPI specification..."
	oapi-codegen -generate types,client -package v1 ${DEVGRAPH_API_SPEC} > pkg/apis/devgraph/v1/api.go
