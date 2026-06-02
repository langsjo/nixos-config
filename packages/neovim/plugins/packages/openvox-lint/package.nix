{
  bundlerApp,
  bundlerUpdateScript,
  lib,
  testers,
}:

(bundlerApp {
  pname = "puppet-lint";
  gemdir = ./.;
  exes = [ "puppet-lint" ];

  passthru = {
    tests.version = testers.testVersion {
      #package = openvox-lint;
      inherit ((import ./gemset.nix).puppet-lint) version;
    };
    updateScript = bundlerUpdateScript "openvox-lint";
  };

  meta = {
    description = "Checks Puppet code against the recommended Puppet language style guide";
    #homepage = "https://github.com/puppetlabs/puppet-lint";
    #changelog = "https://github.com/puppetlabs/puppet-lint/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "puppet-lint";
    maintainers = with lib.maintainers; [ skyethepinkcat ];
  };
}).overrideAttrs
  (_: {
    version = (import ./gemset.nix).puppet-lint.version;
  })
