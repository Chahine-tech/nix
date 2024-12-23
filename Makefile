.PHONY: dev build-all build-api build-metrics build-worker run-api run-metrics run-worker docker-up docker-down

# Development
dev:
	nix develop

# Build commands
build-all:
	nix build .#api
	nix build .#metrics
	nix build .#worker

build-api:
	nix build .#api

build-metrics:
	nix build .#metrics

build-worker:
	nix build .#worker

# Run commands
run-api:
	nix run .#api

run-metrics:
	nix run .#metrics

run-worker:
	nix run .#worker

# Docker commands
docker-up:
	docker-compose up --build

docker-down:
	docker-compose down

# Clean
clean:
	docker-compose down -v
	rm -rf result*

# Help
help:
	@echo "Available commands:"
	@echo "  make dev          - Enter Nix development shell"
	@echo "  make build-all    - Build all services"
	@echo "  make build-api    - Build API service"
	@echo "  make build-metrics- Build metrics service"
	@echo "  make build-worker - Build worker service"
	@echo "  make run-api      - Run API service"
	@echo "  make run-metrics  - Run metrics service"
	@echo "  make run-worker   - Run worker service"
	@echo "  make docker-up    - Start all services with Docker"
	@echo "  make docker-down  - Stop all Docker services"
	@echo "  make clean        - Clean up build artifacts and Docker volumes" 