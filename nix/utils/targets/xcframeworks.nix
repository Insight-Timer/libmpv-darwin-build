let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# FLTR-20042 IT-minimal: only the iOS universal xcframework is produced.
# This single bundle contains both ios-arm64 and ios-arm64_x86_64-simulator
# slices, which is everything media_kit_libs_ios_video needs.
# macOS xcframework dropped — IT doesn't ship a macOS app.
[
  {
    os = oses.ios;
    arch = archs.universal;
  }
]
