# Go Microservices with Nix

A modern microservices architecture built with Go and managed with Nix. This project demonstrates how to build and run multiple Go services using Nix for reproducible development environments and builds.

## Project Structure

```
.
├── apps/
│   ├── api/             # Main API service
│   │   ├── main.go
│   │   ├── go.mod
│   │   └── Dockerfile
│   ├── worker/          # Background worker service
│   │   ├── main.go
│   │   ├── go.mod
│   │   └── Dockerfile
│   └── metrics/         # Metrics service
│       ├── main.go
│       ├── go.mod
│       └── Dockerfile
├── pkg/                 # Shared packages
│   ├── logger/          # Common logging package
├── flake.nix           # Nix flake configuration
├── flake.lock          # Nix flake lock file
└── docker-compose.yml  # Docker services configuration
```

## Services

1. **API Service** (Port 8080)
   - Main HTTP API service
   - Handles incoming requests
   - Uses shared logging package

2. **Metrics Service** (Port 8081)
   - Exposes service metrics
   - Tracks request counts
   - Provides health checks

3. **Worker Service**
   - Background processing
   - Handles async tasks
   - Demonstrates periodic job execution

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

1. **Enable Nix Flakes**

   Add to your `~/.config/nix/nix.conf`:
   ```
   experimental-features = nix-command flakes
   ```

2. **Clone the Repository**
   ```bash
   git clone https://github.com/Chahine-tech/nix.git
   cd nix
   ```

3. **Development Environment**
   ```bash
   # Enter Nix development shell
   make dev
   ```

## Running the Services

### Using Docker (Recommended for Development)

Start all services:
```bash
make docker-up
```

Stop all services:
```bash
make docker-down
```

Clean up:
```bash
make clean
```

### Using Nix Directly

Build individual services:
```bash
make build-api
make build-metrics
make build-worker
```

Run individual services:
```bash
make run-api
make run-metrics
make run-worker
```

## Development

Each service can be developed independently while sharing common code through the `pkg` directory.

### Available Make Commands

- `make dev` - Enter Nix development shell
- `make build-all` - Build all services
- `make build-api` - Build API service
- `make build-metrics` - Build metrics service
- `make build-worker` - Build worker service
- `make run-api` - Run API service
- `make run-metrics` - Run metrics service
- `make run-worker` - Run worker service
- `make docker-up` - Start all services with Docker
- `make docker-down` - Stop all Docker services
- `make clean` - Clean up build artifacts and Docker volumes

## Testing the Services

1. **API Service**
   ```bash
   curl http://localhost:8080
   ```

2. **Metrics Service**
   ```bash
   curl http://localhost:8081/metrics
   ```

## Project Features

- **Reproducible Development**: Nix ensures consistent development environments
- **Containerization**: Docker support for easy deployment
- **Shared Code**: Common packages in `pkg` directory
- **Structured Logging**: JSON logging with logrus
- **Metrics**: Built-in metrics service
- **Background Processing**: Worker service for async tasks

## Nix Configuration

The project uses a Nix flake for:
- Reproducible development environment
- Consistent Go version across services
- Development tools (gopls, go-tools)
- Hot reload capability with Air

## Docker Configuration

Each service has its own Dockerfile and shares:
- Common Nix environment
- Shared packages
- Volume mounts for development
- Network configuration

