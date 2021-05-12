DOTPATH := $(shell cd $(dir $(lastword $(MAKEFILE_LIST))); pwd)

.PHONY: all list deploy init update install test clean help

all: install

list: ## Show dot files in this repo
	@echo $(CANDIDATES)
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/.setup/link.sh

init: ## Setup environment settings
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/.setup/init.sh

# test: ## Test dotfiles and init scripts
# 	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

update: ## Fetch changes for this repo
	git pull origin main

install: update init deploy ## Run make update, init, deploy
	zsh -l -c 'exit'

test:
	zsh -i $(DOTPATH)/test/main.zsh

clean: ## Remove the dot files and this repo
	# @echo 'Remove dot files in your home directory...'
	# @-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	# -rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m=>  %s\n", $$1, $$2}'
