DOTPATH := $(shell cd $(dir $(lastword $(MAKEFILE_LIST))); pwd)
HOMEBREW_PREFIX :=
SUDO := 0
FULL_INSTALL := 0

SHELL := /bin/zsh

.PHONY: all list deploy init update install test clean help

all: install

deploy: ## Create symlink to home directory
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/deploy/main.sh

init: ## Setup environment settings
	HOMEBREW_PREFIX=$(HOMEBREW_PREFIX) SUDO=$(SUDO) FULL_INSTALL=$(FULL_INSTALL) \
	bash $(DOTPATH)/init/main.sh

update: ## Fetch changes for this repo
	git pull origin main

upgrade: ## Upgrade installed packages
	brew update && brew upgrade && brew cleanup
	(type pipx &> /dev/null) && pipx upgrade-all
	pip3 install -U pip
	pkgs="$$(pip3 list --user -o --disable-pip-version-check | tail -n +3 | awk '{ print $$1 }')"; \
	[[ -n $$pkgs ]] && pip3 install --user -U $$pkgs || true
	(type npm &> /dev/null) && npm update -g || true
	(type zinit &> /dev/null) && zinit update --all || true

install: update init deploy ## Run make update, init, deploy
	zsh -l -c 'exit'

test: ## Test if expected tools are installed
	zsh -i $(DOTPATH)/test/main.zsh

# clean: ## Remove the dot files and this repo
# 	@echo 'Remove dot files in your home directory...'
# 	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
# 	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m=>  %s\n", $$1, $$2}'
