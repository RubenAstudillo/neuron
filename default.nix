let
  # To upgrade rib, go to https://github.com/srid/rib/commits/master, select the
  # revision you would like to upgrade to and set it here. Consult rib's
  # ChangeLog.md to check any notes on API migration.
  ribRevision = "39265998b80711421abd4c81e50724b310b6c9b7";

  inherit (import (builtins.fetchTarball "https://github.com/hercules-ci/gitignore/archive/7415c4f.tar.gz") { }) gitignoreSource;
in {
# Rib library source to use
  rib ? builtins.fetchTarball "https://github.com/srid/rib/archive/${ribRevision}.tar.gz"
# Cabal project root
, root ? gitignoreSource ./.
# Cabal project name
, name ? "neuron"
, ...
}:

let 
  source-overrides = {
  };
in import rib { 
  inherit root name source-overrides; 
}
