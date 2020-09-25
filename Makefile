.DEFAULT_GOAL = help

export SHELL := /bin/bash

include etc/nix.mk

export PATH := $(PATH)

OPT =
BIN ?= pulugu

dev: clean ## build continuously
	@cabal build 2>&1 | source-highlight --src-lang=haskell --out-format=esc
	@fswatcher --path . --include "\.hs$$|\.cabal$$" --throttle 31 cabal -- $(OPT) build 2>&1 \
	| source-highlight --src-lang=haskell --out-format=esc

dev-ghcid: clean ##
	@ghcid --command="cabal $(OPTS) repl -fwarn-unused-binds -fwarn-unused-imports -fwarn-orphans" \
	       --reload=app/lamh.hs \
	       --restart=lamh.cabal \
	| source-highlight --src-lang=haskell --out-format=esc

build: clean # lint (breaks on multiple readers) ## build
	cabal configure --ghc | source-highlight --src-lang=haskell --out-format=esc
	cabal build

build-js: clean # lint (breaks on multiple readers) ## build
	cabal configure --ghcjs | source-highlight --src-lang=haskell --out-format=esc
	cabal build

test: ## test
	cabal $(OPT) test

lint: ## lint
	hlint app src

clean: ## clean
	cabal $(OPT) clean

run: ## run main, default: BIN=lamh
	cabal $(OPT) run ${BIN}

repl: ## repl
	cabal $(OPT) repl

help: ## help
	-@grep --extended-regexp '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed 's/^Makefile://1' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
	-@ghc --version
	-@ghcjs --version
	-@cabal --version
	-@hlint --version
	-@ghcid --version --ignore-loaded
	-@echo BIN=$(BIN)
	-@echo NIX_SSL_CERT_FILE=${NIX_SSL_CERT_FILE}

# @todo: not indempotent--fix later
init: ## init project but run "make -f ete/init.mk install-nix" first
	${MAKE} -f etc/init.mk init

install-nix: # install nix
	${MAKE} -f etc/init.mk install-nix

shell: ## initialize project
	${MAKE} -f etc/init.mk nix-shell

# @todo: not indempotent--fix later
update: ## update project depedencies
	${MAKE} -f etc/init.mk cabal-update
	${MAKE} -f etc/init.mk install-pkgs

curl: ## curl --head https://google.com
	echo $(NIX_SSL_CERT_FILE)
	curl --head https://google.com/
