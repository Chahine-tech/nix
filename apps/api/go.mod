module github.com/Chahine-tech/nix/apps/api

go 1.21

require github.com/Chahine-tech/nix/pkg v0.0.0

require (
	github.com/sirupsen/logrus v1.9.3 // indirect
	golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect
)

replace github.com/Chahine-tech/nix/pkg => ../../pkg
