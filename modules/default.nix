# Main module configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    ./api
    ./metrics
    ./worker
  ];
} 