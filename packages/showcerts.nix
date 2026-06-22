{
  writeShellApplication,
  openssl,
}:
writeShellApplication {
  name = "showcerts";
  runtimeInputs = [ openssl ];
  text = ''
    fqdn=''${1?"give fqdn pls"}
    openssl s_client -connect "$fqdn":443 -servername "$fqdn" -showcerts </dev/null 2>/dev/null \
      | openssl x509 -noout -subject -ext subjectAltName -issuer -dates
  '';
}
