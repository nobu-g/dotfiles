DOTPATH := $(shell readlink -f $(dir $(lastword $(MAKEFILE_LIST))))

all: install

list: ## Show dot files in this repo
	@echo $(CANDIDATES)
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create symlink to home directory
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/link.sh

init: ## Setup environment settings
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/init.sh

# test: ## Test dotfiles and init scripts
# 	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/test/test.sh

update: ## Fetch changes for this repo
	git pull origin master

install: update init deploy ## Run make update, init, deploy
	@exec $$SHELL -l
	@zinit self-update
	@fast-theme XDG:overlay

clean: ## Remove the dot files and this repo
	# @echo 'Remove dot files in your home directory...'
	# @-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	# -rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m=>  %s\n", $$1, $$2}'
