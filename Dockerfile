FROM nixos/nix:latest

WORKDIR /app

COPY . .

# Enable flakes (plus simple)
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

EXPOSE 8080

ENTRYPOINT ["nix", "develop", "-c", "go", "run", "main.go"]