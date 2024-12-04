{ config, variables, inputs, system, ... }:
let
  inherit (variables) userName;
  homeDir = config.users.users.${userName}.home;
in 
  {
  environment.systemPackages = [
    inputs.ragenix.packages.${system}.ragenix
  ];

  age = {
    # Private identity keys for decrypting secrets
    # Defaults to ~/.ssh/id_ed25519 and ~/.ssh/id_rsa
    identityPaths = [ 
      "${homeDir}/.secrets/master.age.key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    secrets = { 
      github-key = { 
        file = ./secrets/github-key.age;
        owner = userName;
        mode = "600";
      };
      github-pat = {
        file = ./secrets/github-pat.age;
        owner = userName;
        mode = "600";
      };
      graphite = {
        file = ./secrets/graphite.age;
        path = "${homeDir}/.config/graphite/user_config";
        owner = userName;
        mode = "600";
      };
    };
  };
}
