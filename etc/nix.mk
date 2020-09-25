export NIX_SSL_CERT_FILE = ${HOME}/.nix-profile/etc/ssl/certs/ca-bundle.crt
# @todo: remove these later
export NIX_PATH = ${HOME}/.nix-defexpr/channels
export NIX_PROFILES = "/nix/var/nix/profiles/default ${HOME}/.nix-profile"
export PATH := $(PATH):$(HOME)/.nix-profile/bin:/usr/bin
