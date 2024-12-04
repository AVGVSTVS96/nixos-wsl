let
  wsl-desktop-home-ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/HJtpzR8Ip/ma38TQSj1Uvl/rvvN3ogYsTbD8ERErL";
  wsl-desktop-host-ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/ppkYVMKZ+N/BINzfEvO8mWZMtx/UgbrHf5i4wpb77";
  wsl-laptop-home-ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeABSDuLTLywoc86FINzl/YsUfJ0yqPhPan4DUzT2ME";
  wsl-laptop-host-ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZXcr0Kw5hXygTBzIbeh6RkBK+DifY2C8ywiIGC1jdj";
  age-master = "age12cxan60rykh0luc7xqasvlpgfvgyxecz2w64av422fxa4qnj7dvsu5jd74";

  hostKeys = [
    wsl-desktop-host-ssh
    wsl-laptop-host-ssh
  ];

  homeKeys = [
    wsl-desktop-home-ssh
    wsl-laptop-home-ssh
  ];

  masterKeys = [
    age-master
  ];

in

  {
  "github-key.age".publicKeys = hostKeys ++ homeKeys ++ masterKeys;
  "github-pat.age".publicKeys = hostKeys ++ homeKeys ++ masterKeys;
  "graphite.age".publicKeys = hostKeys ++ homeKeys ++ masterKeys;
}

