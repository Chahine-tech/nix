FROM nixos/nix:latest

WORKDIR /app

# Copy Nix files
COPY flake.nix flake.lock ./

# Copy pkg directory
COPY pkg ./pkg/

# Copy metrics files
COPY apps/metrics ./apps/metrics/

# Enable flakes
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

EXPOSE 8081

WORKDIR /app/apps/metrics
CMD ["nix", "develop", "-c", "go", "run", "main.go"] 