# Go Microservices with Nix

This project demonstrates a microservices architecture using Go and Nix for reproducible builds and deployments.

## Project Structure

```
.
├── flake.nix           # Main Nix configuration
├── apps/               # Application services
├── pkg/                # Shared Go packages
├── modules/            # NixOS modules
└── nix/                # Additional Nix configurations
    ├── ci.nix         # CI/CD configuration
    └── test-config.nix # NixOS module tests
```

## Services

- **API**: HTTP API service (port 8080)
- **Metrics**: Metrics collection service (port 8081)
- **Worker**: Background job processor

## Development

### Prerequisites

- Nix with flakes enabled

### Commands

1. Enter development shell:
```bash
nix develop
```

2. Build a service:
```bash
nix build .#api
nix build .#metrics
nix build .#worker
```

3. Build a container:
```bash
nix build .#containers.api
nix build .#containers.metrics
nix build .#containers.worker
```

4. Load container into Docker:
```bash
docker load < result
```

### Testing

1. Run NixOS module tests:
```bash
nix-build nix/test-config.nix -A test
```

2. Build and run test VM:
```bash
nix-build nix/test-config.nix -A vm
./result/bin/run-*-vm
```

3. Run service tests:
```bash
nix build .#checks.x86_64-linux.test-all
```

### Development Tips

- Use `air` for hot reloading during development
- Each service has its own `go.mod` for dependency management
- Shared code lives in the `pkg` directory
- Test new NixOS modules using `nix/test-config.nix`

## Deployment

The project includes NixOS modules for deployment. Configure services in your NixOS configuration:

```nix
{ config, ... }:
{
  imports = [ ./modules ];
  
  services.myapp = {
    api.enable = true;
    metrics.enable = true;
    worker.enable = true;
  };
}
```

## Container Images

Container images are built using Nix's `dockerTools` for maximum reproducibility. Images are minimal and contain only the necessary binaries.

## Testing New Modules

When adding new modules or modifying existing ones:

1. Add the module to `modules/`
2. Update `modules/default.nix` to import it
3. Add configuration to `nix/test-config.nix`
4. Test using:
   ```bash
   nix-build nix/test-config.nix -A test
   ```
5. For interactive testing, run the VM:
   ```bash
   nix-build nix/test-config.nix -A vm
   ./result/bin/run-*-vm
   ```

