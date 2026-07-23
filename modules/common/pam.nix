{
  pkgs,
  ...
}:
let
  u2f_keys = pkgs.writeText "u2f_keys" ''
    langsjo:F89neesB7P8crFep7rF8hzhuTC3RkP7dSQwk8IA4dux5ltVya+Ak/i6gu2Gb1i2CKEBTc1tqnKIupYv6q6gLsw==,jGIYA4X3VrYAgWihHGRgdo0kcyVp+lAIJhStjpuSKqkhROEwIMO1nr5dAsr+3GSZg+z1JSB+KORUD/n/VW5A4w==,es256,+presence:Oagk9w3qGOiRZltBzOoZ3DUNe3cKomnDX8FM2P65EZc9fHKethtPc6M1BNdr5XGRyiH3Z2vBcOP/dckFGvysYA==,ONyt9lDCtRkcB4NESxUyme6a+Qq1SbWmB2VGZltlr0hbjHzu9spAfyICrIJ+MbwjgMsBcfXAt5nnotdlgQsW0g==,es256,+presence
  '';
in
{
  security.pam = {
    u2f.settings = {
      authfile = u2f_keys;
      cue = true;
      origin = "default";
    };
    services = {
      sudo.u2fAuth = true;
      login.u2fAuth = true;
    };
  };
}
