DOTPATH := $(shell cd $(dir $(lastword $(MAKEFILE_LIST))); pwd)
HOMEBREW_PREFIX :=
FULL_INSTALL := 0

.PHONY: all list deploy init update install test clean help

all: install

deploy: ## Create symlink to home directory
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/deploy/main.sh

init: ## Setup environment settings
	@DOTPATH=$(DOTPATH) HOMEBREW_PREFIX=$(HOMEBREW_PREFIX) FULL_INSTALL=$(FULL_INSTALL) bash $(DOTPATH)/init/main.sh

# test: ## Test dotfiles and init scripts
# 	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

update: ## Fetch changes for this repo
	git pull origin main

install: update init deploy ## Run make update, init, deploy
	zsh -l -c 'exit'

test:
	zsh -i $(DOTPATH)/test/main.zsh

# clean: ## Remove the dot files and this repo
# 	@echo 'Remove dot files in your home directory...'
# 	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
# 	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m=>  %s\n", $$1, $$2}'
