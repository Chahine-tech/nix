FROM nixos/nix:latest

WORKDIR /app

# Copy Nix files
COPY flake.nix flake.lock ./

# Copy pkg directory
COPY pkg ./pkg/

# Copy worker files
COPY apps/worker ./apps/worker/

# Enable flakes
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

WORKDIR /app/apps/worker
CMD ["nix", "develop", "-c", "go", "run", "main.go"] 