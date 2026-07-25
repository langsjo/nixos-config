{
  lib,
  swayidle,
  swaylock,
  lockCmd ? "${lib.getExe swaylock} -f",
}:
{
  package = swayidle;
  flags.path."-C"."/".text = ''
    timeout 300 '${lockCmd}'
    before-sleep '${lockCmd}'
    lock '${lockCmd}'
  '';
}
