{
  lib,
  niri-wrapped,
  nixGL ? null,
}:
{
  package = niri-wrapped;
  useBinaryWrapper = false;
  includeBins = [ "niri" ];
  extraMakeWrapperArgs = [
    # source nixGL variables without running the exec
    "--run"
    "source <(grep -v '^\\s*exec' \"${lib.getExe nixGL}\")"
  ];
}
