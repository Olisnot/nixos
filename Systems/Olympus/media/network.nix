{ config, lib, ... }:

let
  ports = import ./ports.nix;
  privatePorts = builtins.attrValues ports;
in
{
  # These are not public ports: only packets arriving on wg0 may reach them.
  networking.firewall.interfaces.wg0.allowedTCPPorts = privatePorts;
  olympusMobileVpn.allowedServicePorts = privatePorts;

  # Fail evaluation if a future service module accidentally opens a backend
  # globally. Only Caddy is the public entry point for public media services.
  assertions = [
    {
      assertion = lib.all (
        port:
        !(builtins.elem port [
          22
          2019
          8096
          8920
          5055
          4533
          8191
        ])
      ) privatePorts;
      message = "Private media UI ports must not collide with SSH, Caddy admin or public-service backends.";
    }
    {
      assertion = lib.all (port: !(builtins.elem port config.networking.firewall.allowedTCPPorts)) (
        privatePorts
        ++ [
          8096
          8920
          5055
          4533
          8191
          51413
        ]
      );
      message = "Olympus media backend/admin ports must not be opened globally; use Caddy or wg0.";
    }
  ];
}
