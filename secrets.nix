{ config, variables, inputs, ... }:
let
  inherit (variables) userName;
  homeDir = config.users.users.${userName}.home;
in 
  {
  environment.systemPackages = [
    inputs.ragenix.packages."x86_64-linux".ragenix
  ];

  age = {
    identityPaths = [ "${homeDir}/.secrets/master.age.key"];
    secrets = { 
      github-key = { 
        file = ./secrets/github-key.age;
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
