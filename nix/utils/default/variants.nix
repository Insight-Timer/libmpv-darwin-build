let
  variants = import ../constants/variants.nix;
in
# FLTR-20042 IT-minimal: only `video` variant is built in CI.
# The audio-only variant is unused — media_kit_libs_ios_video pulls the
# video xcframeworks which can play audio-only sources too.
[
  variants.video
]
