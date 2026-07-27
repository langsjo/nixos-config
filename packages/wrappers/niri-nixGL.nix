{
  niri-wrapped,
}:
{
  package = niri-wrapped;
  useBinaryWrapper = false;
  includeBins = [ "niri" ];
  extraMakeWrapperArgs = [
    # source nixGL variables without running the exec
    "--run"
    "source <(grep '^export' \"$(which nixGL)\")"
  ];
}
