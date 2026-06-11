let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# FLTR-20042 IT-minimal: per-arch lib tarballs disabled.
# We only consume the iOS universal xcframework (see xcframeworks.nix), so
# building separate ios-arm64 / iossimulator-arm64 / iossimulator-amd64 /
# macos-* libs tarballs just burns CI time. The xcframework still gets all
# the slices it needs (mk-out-xcframeworks calls into mk-out-frameworks
# directly with the OS values it needs — it does not consume this list).
# Re-add entries here if you want raw `.a` / `.dylib` artifacts.
[
]
