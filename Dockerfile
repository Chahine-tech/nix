FROM nixos/nix:latest

WORKDIR /app

# Copy files needed for Nix
COPY flake.nix .
COPY flake.lock* .
COPY main.go .
COPY go.mod .

# Enable flakes
RUN mkdir -p ~/.config/nix && \
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Build and run using Nix
EXPOSE 8080

# Use nix develop to run the application
ENTRYPOINT ["nix", "--extra-experimental-features", "nix-command flakes", "develop", "-c", "go", "run", "main.go"]