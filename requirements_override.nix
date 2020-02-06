{ pkgs, python }:

self: super: {
  # ipython = pkgs.python3Packages.ipython;

  # pycparser = pkgs.python3Packages.pycparser;
  # cffi = pkgs.python3Packages.cffi;

  "cffi" = python.overrideDerivation super."cffi" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ (with self; with pkgs; [
      libffi
    ]);
   });

  "pytest-runner" = python.overrideDerivation super."pytest-runner" (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ self."setuptools-scm" ];
  });

  "wheel" = python.overrideDerivation super."wheel" (old: {
    # Prevent the `pipInstallPhase` from attempting to uninstall existing wheel
    # which is doomed to fail as the nix store is RO.
    pipInstallFlags = [ "--ignore-installed" ];
  });

  "jira" = python.overrideDerivation super."jira" (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ (with self; with pkgs; [
      pbr
      pytest-runner
      cryptography
      pyjwt
      libffi
      # sphinx
    ]);

    doCheck = false;

    patchPhase = ''
      sed -i -E -e "s|, 'sphinx[^']*'||" \
        setup.py
    '';
   });

  # pbr>=3.0.0', 'setuptools>=17.1', 'pytest-runner', 'sphinx
}