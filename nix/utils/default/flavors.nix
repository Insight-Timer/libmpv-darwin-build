let
  flavors = import ../constants/flavors.nix;
in
# FLTR-20042 IT-minimal: only `default` flavor is built in CI.
# `full` and `encodersgpl` are unused by Insight Timer — re-add them here
# if you need encoder support or the full upstream feature set.
[
  flavors.default
]
