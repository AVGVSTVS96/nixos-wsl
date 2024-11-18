let
  github = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/HJtpzR8Ip/ma38TQSj1Uvl/rvvN3ogYsTbD8ERErL";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/ppkYVMKZ+N/BINzfEvO8mWZMtx/UgbrHf5i4wpb77";
  age = "age12cxan60rykh0luc7xqasvlpgfvgyxecz2w64av422fxa4qnj7dvsu5jd74";

  keys = [ github system age ];
in {
  "github-key.age".publicKeys = keys;
  "graphite.age".publicKeys = keys;
}
