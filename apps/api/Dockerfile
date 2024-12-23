FROM nixos/nix:latest

WORKDIR /app

# Copy Nix files
COPY flake.nix flake.lock ./

# Copy pkg directory
COPY pkg ./pkg/

# Copy API files
COPY apps/api ./apps/api/

# Enable flakes
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

EXPOSE 8080

WORKDIR /app/apps/api
CMD ["nix", "develop", "-c", "go", "run", "main.go"] 