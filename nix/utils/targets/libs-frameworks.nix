let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# FLTR-20042 IT-minimal: only the iOS chain is kept.
#
# This list serves two purposes — both consumers re-import it:
#   1. nix/utils/targets/archives.nix uses it to decide which per-arch
#      `libmpv-libs_*` tarballs to produce as top-level CI artifacts.
#   2. nix/packages/mk-out-libs/targets.nix → mk-out-libs/default.nix
#      uses it on the universal-arch path to find which per-arch slices
#      to `lipo -create` into the universal dylib that feeds the
#      xcframework. Emptying the list silently produces empty archives.
#
# Minimum entries required for the ios-universal xcframework:
#   - {ios, arm64}            — device slice
#   - {iossimulator, arm64}   — simulator slice (Apple Silicon)
#   - {iossimulator, amd64}   — simulator slice (Intel)
#   - {iossimulator, universal} — lipo'd simulator slice used by mk-out-frameworks
#
# Dropped: all 3 macos-* entries (IT has no macOS app).
[
  {
    os = oses.ios;
    arch = archs.arm64;
  }
  {
    os = oses.iossimulator;
    arch = archs.arm64;
  }
  {
    os = oses.iossimulator;
    arch = archs.amd64;
  }
  {
    os = oses.iossimulator;
    arch = archs.universal;
  }
]
