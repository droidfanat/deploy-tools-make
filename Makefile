#!/usr/bin/make
# Makefile readme (ru): <http://linux.yaroslavl.ru/docs/prog/gnu_make_3-79_russian_manual.html>
# Makefile readme (en): <https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents>

SHELL = /bin/bash

export VALERKA_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
export VALERKA_CONFIG_DIR = $(HOME)/.valerka

REGISTRY_HOST = index.docker.io
REGISTRY_PATH = artjoker/laravel_
IMAGES_PREFIX := $(shell basename $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PROJECT_NAME = $(shell basename $(shell readlink -f $(VALERKA_CONFIG_DIR)/src))

PUBLISH_TAGS = latest
PULL_TAG = latest

# Important: Local images naming should be in docker-compose naming style

APP_IMAGE = $(REGISTRY_HOST)/$(REGISTRY_PATH)app
APP_IMAGE_LOCAL_TAG = $(IMAGES_PREFIX)_app
APP_IMAGE_DOCKERFILE = $(VALERKA_DIR)/docker/app/Dockerfile
APP_IMAGE_CONTEXT = $(VALERKA_DIR)/docker/app

NODE_IMAGE = $(REGISTRY_HOST)/$(REGISTRY_PATH)node
NODE_IMAGE_LOCAL_TAG = $(IMAGES_PREFIX)_node
NODE_IMAGE_DOCKERFILE = $(VALERKA_DIR)/docker/node/Dockerfile
NODE_IMAGE_CONTEXT = $(VALERKA_DIR)/docker/node

SOURCES_IMAGE = $(REGISTRY_HOST)/$(REGISTRY_PATH)sources
SOURCES_IMAGE_LOCAL_TAG = $(IMAGES_PREFIX)_sources
SOURCES_IMAGE_DOCKERFILE = $(VALERKA_DIR)/docker/sources/Dockerfile
SOURCES_IMAGE_CONTEXT = $(VALERKA_CONFIG_DIR)/src

NGINX_IMAGE = $(REGISTRY_HOST)/$(REGISTRY_PATH)nginx
NGINX_IMAGE_LOCAL_TAG = $(IMAGES_PREFIX)_nginx
NGINX_IMAGE_DOCKERFILE = $(VALERKA_DIR)/docker/nginx/Dockerfile
NGINX_IMAGE_CONTEXT = $(VALERKA_DIR)/docker/nginx

APP_CONTAINER_NAME := app
NODE_CONTAINER_NAME := node
SQL_CONTAINER_NAME := mysql

SQL_USER := homestead
SQL_DB := homestead
SQL_PASS := secret

docker_bin := $(shell command -v docker 2> /dev/null)
docker_compose_bin = $(shell echo "$(shell command -v docker-compose 2> /dev/null)" "-p" "$(PROJECT_NAME)" -f $(VALERKA_DIR)/docker-compose.yml)

all_images = $(APP_IMAGE) \
             $(APP_IMAGE_LOCAL_TAG) \
             $(SOURCES_IMAGE) \
             $(SOURCES_IMAGE_LOCAL_TAG) \
             $(NGINX_IMAGE) \
             $(NGINX_IMAGE_LOCAL_TAG)

ifeq "$(REGISTRY_HOST)" "registry.gitlab.com"
	docker_login_hint ?= "\n\
	**************************************************************************************\n\
	* Make your own auth token here: <https://gitlab.com/profile/personal_access_tokens> *\n\
	**************************************************************************************\n"
endif

.PHONY : help pull build push login test clean \
         app-pull app app-push\
         sources-pull sources sources-push\
         nginx-pull nginx nginx-push\
         up down restart shell install
.DEFAULT_GOAL := help

# This will output the help for each task. thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help
	@echo
	@echo " ██╗   ██╗ █████╗ ██╗     ███████╗██████╗ ██╗  ██╗ █████╗ "
	@echo " ██║   ██║██╔══██╗██║     ██╔════╝██╔══██╗██║ ██╔╝██╔══██╗"
	@echo " ██║   ██║███████║██║     █████╗  ██████╔╝█████╔╝ ███████║"
	@echo " ╚██╗ ██╔╝██╔══██║██║     ██╔══╝  ██╔══██╗██╔═██╗ ██╔══██║"
	@echo "  ╚████╔╝ ██║  ██║███████╗███████╗██║  ██║██║  ██╗██║  ██║"
	@echo "   ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝"
	@echo -e "\n $(shell cd $(VALERKA_DIR) && git describe --tags) \n\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo -e "\n \e[36m First start project:\e[0m\n\
		valerka init \n\
	\n \e[36m Stop project:\e[0m\n\
		valerka stop \n\
	\n \e[36m Start project:\e[0m\n\
		valerka start \n\
	"

docker-install: ## Install docker to machine 
	bash $(VALERKA_DIR)/scripts/docker-install.sh

check-update: ## Check update valerka
	@bash $(VALERKA_DIR)/scripts/check_for_update.sh

valerka-install: ## Install valerka to machine
	@bash ./install-valerka.sh

valerka-update: ## Update valerka in machine
	@bash $(VALERKA_DIR)/scripts/update.sh
	valerka pull

valerka-remove: ## Uninstall valerka to machine
	@bash ./install-valerka.sh remove

---------------: ## ---------------

# --- [ Application ] -------------------------------------------------------------------------------------------------

app-pull: ## Application - pull latest Docker image (from remote registry)
	-$(docker_bin) pull "$(APP_IMAGE):$(PULL_TAG)"

app: app-pull ## Application - build Docker image locally
	$(docker_bin) build \
	  --cache-from "$(APP_IMAGE):$(PULL_TAG)" \
	  --tag "$(APP_IMAGE_LOCAL_TAG)" \
	  -f $(APP_IMAGE_DOCKERFILE) $(APP_IMAGE_CONTEXT)

app-push: app-pull ## Application - tag and push Docker image into remote registry
	$(docker_bin) build \
	  --cache-from "$(APP_IMAGE):$(PULL_TAG)" \
	  $(foreach tag_name,$(PUBLISH_TAGS),--tag "$(APP_IMAGE):$(tag_name)") \
	  -f $(APP_IMAGE_DOCKERFILE) $(APP_IMAGE_CONTEXT);
	$(foreach tag_name,$(PUBLISH_TAGS),$(docker_bin) push "$(APP_IMAGE):$(tag_name)";)

# --- [ Node JS ] -------------------------------------------------------------------------------------------------

node-pull: ## Node JS - pull latest Docker image (from remote registry)
	-$(docker_bin) pull "$(NODE_IMAGE):$(PULL_TAG)"

node: node-pull ## Node JS - build Docker image locally
	$(docker_bin) build \
	  --cache-from "$(NODE_IMAGE):$(PULL_TAG)" \
	  --tag "$(NODE_IMAGE_LOCAL_TAG)" \
	  -f $(NODE_IMAGE_DOCKERFILE) $(NODE_IMAGE_CONTEXT)

node-push: node-pull ## Node JS - tag and push Docker image into remote registry
	$(docker_bin) build \
	  --cache-from "$(NODE_IMAGE):$(PULL_TAG)" \
	  $(foreach tag_name,$(PUBLISH_TAGS),--tag "$(NODE_IMAGE):$(tag_name)") \
	  -f $(NODE_IMAGE_DOCKERFILE) $(NODE_IMAGE_CONTEXT);
	$(foreach tag_name,$(PUBLISH_TAGS),$(docker_bin) push "$(NODE_IMAGE):$(tag_name)";)

# --- [ Sources ] -----------------------------------------------------------------------------------------------------

sources-pull: ## Sources - pull latest Docker image (from remote registry)
	-$(docker_bin) pull "$(SOURCES_IMAGE):$(PULL_TAG)"

sources: ## Sources - build Docker image locally
	$(docker_bin) build \
	  --tag "$(SOURCES_IMAGE_LOCAL_TAG)" \
	  -f $(SOURCES_IMAGE_DOCKERFILE) $(SOURCES_IMAGE_CONTEXT)

sources-push: ## Sources - tag and push Docker image into remote registry
	$(docker_bin) build \
	  $(foreach tag_name,$(PUBLISH_TAGS),--tag "$(SOURCES_IMAGE):$(tag_name)") \
	  -f $(SOURCES_IMAGE_DOCKERFILE) $(SOURCES_IMAGE_CONTEXT);
	$(foreach tag_name,$(PUBLISH_TAGS),$(docker_bin) push "$(SOURCES_IMAGE):$(tag_name)";)

# --- [ Nginx ] -------------------------------------------------------------------------------------------------------

nginx-pull: ## Nginx - pull latest Docker image (from remote registry)
	-$(docker_bin) pull "$(NGINX_IMAGE):$(PULL_TAG)"

nginx: nginx-pull ## Nginx - build Docker image locally
	$(docker_bin) build \
	  --cache-from "$(NGINX_IMAGE):$(PULL_TAG)" \
	  --tag "$(NGINX_IMAGE_LOCAL_TAG)" \
	  -f $(NGINX_IMAGE_DOCKERFILE) $(NGINX_IMAGE_CONTEXT)

nginx-push: nginx-pull ## Nginx - tag and push Docker image into remote registry
	$(docker_bin) build \
	  --cache-from "$(NGINX_IMAGE):$(PULL_TAG)" \
	  $(foreach tag_name,$(PUBLISH_TAGS),--tag "$(NGINX_IMAGE):$(tag_name)") \
	  -f $(NGINX_IMAGE_DOCKERFILE) $(NGINX_IMAGE_CONTEXT);
	$(foreach tag_name,$(PUBLISH_TAGS),$(docker_bin) push "$(NGINX_IMAGE):$(tag_name)";)

# ---------------------------------------------------------------------------------------------------------------------

pull: app-pull node-pull nginx-pull ## Pull all Docker images (from remote registry)

build: app node sources nginx ## Build all Docker images

push: app-push node-push sources-push nginx-push ## Tag and push all Docker images into remote registry

login: ## Log in to a remote Docker registry
	@echo $(docker_login_hint)
	$(docker_bin) login $(REGISTRY_HOST)

# --- [ Development tasks ] -------------------------------------------------------------------------------------------

---------------: ## ---------------

up: ## Start all containers (in background) for development
	$(eval PROJECT_NAME = $(shell basename $(shell readlink -f $(VALERKA_CONFIG_DIR)/src)) )
	if [ -f $(VALERKA_CONFIG_DIR)/src/docker/init.sql ]; then export INIT_SQL_PATH='$(VALERKA_CONFIG_DIR)/src/docker/init.sql'; fi;
	$(docker_compose_bin) up --no-recreate -d

start: up ## Start all containers (in background) for development and clear cache
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" composer dump-autoload
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan cache:clear
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan config:clear
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan view:clear
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan migrate

down-other:
	@## stop containers if that not in valerka docker-compose.yml
	@if [ -n "$(shell docker ps -q)" ]; then echo 'Stop running containers'; docker stop $(shell docker ps -q); fi

down: ## Stop and delete all started for development containers
	$(docker_compose_bin) down
	@valerka down-other

stop: ## Stop all started for development containers
	$(docker_compose_bin) stop

restart: up ## Restart all started for development containers
	$(docker_compose_bin) restart

stop-all: ## Stop all Docker containers in machine
	$(docker_bin) stop $(shell $(docker_bin) ps -aq)
	$(docker_bin) rm $(shell $(docker_bin) ps -aq)

ps: ## List containers
	$(docker_compose_bin) ps
---------------: ## ---------------

shell: up ## Start shell into application container
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" /bin/bash || true

shell-node: up ## NodeJS container start shell 
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" /bin/bash || true

shell-mysql: up ## MySQL container start shell
	$(docker_compose_bin) exec "$(SQL_CONTAINER_NAME)" /bin/sh || true

---------------: ## ---------------

install: up ## Install application dependencies into application container
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" composer install --no-interaction --ansi --no-suggest
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" npm install

remove-dep: ## Remove application dependencies
	rm -rfv .src/vendor/*
	rm -rfv .src/node_modules/* 
	if [ -f $(VALERKA_CONFIG_DIR)/src/composer.lock ]; then rm $(VALERKA_CONFIG_DIR)/src/composer.lock; fi
	if [ -f $(VALERKA_CONFIG_DIR)/src/package-lock.json ]; then rm $(VALERKA_CONFIG_DIR)/src/package-lock.json; fi

reinstall: remove-dep install ## Reinstall application dependencies into application container

fix-env: ## Create .env file from .env.example and fix аccesses
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" sh -c "if [ ! -f .env ]; then cp .env.example .env; fi"
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" sh -c "sed -i \
				-e 's/DB_HOST=.*/DB_HOST=mysql/' \
				-e 's/DB_PORT=.*/DB_PORT=3306/' \
				-e 's/REDIS_HOST=.*/REDIS_HOST=redis/' \
				-e 's/REDIS_PORT=.*/REDIS_PORT=6379/' \
				-e 's/DB_DATABASE=.*/DB_DATABASE=homestead/' \
				-e 's/DB_USERNAME=.*/DB_USERNAME=root/' \
				-e 's/DB_PASSWORD=.*/DB_PASSWORD=secret/' \
				 .env"

---------------: ## ---------------

watch: up ## Start watching assets for changes (node)
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" npm run watch

npm: up ## Start run the bundled code in "production" mode
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" npm run production

npm-dev: up ## Start run the bundled code in "development" mode
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" npm run dev

---------------: ## ---------------

init: add-current set-current install fix-env ## Make full application initialization (install, seed, build assets, etc)
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" sh -c 'if [ -L public/storage ]; then unlink public/storage; fi'
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan storage:link
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan migrate:fresh --force --no-interaction --seed -vvv
	if grep -q test $(VALERKA_CONFIG_DIR)/src/config/database.php; then valerka test-clean; fi
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" artisan key:generate
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" git describe --always --tags > $(VALERKA_CONFIG_DIR)/src/version
	$(docker_compose_bin) run --rm "$(NODE_CONTAINER_NAME)" npm run production

---------------: ## ---------------

test: up ## Execute application tests
	$(docker_compose_bin) exec -e APP_ENV=test "$(APP_CONTAINER_NAME)" phpunit --verbose

test-clean: ## Clean database testme
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" php artisan migrate:fresh --force --no-interaction --seed --database=test

---------------: ## ---------------

clean-docker: ## Remowe unused docker cache
	$(docker_bin) container prune
	$(docker_bin) image prune
	$(docker_bin) network prune
	$(docker_bin) volume prune -f

clean-project: remove-dep ## Remove nmp and composer modules, docker images from local registry
	$(docker_compose_bin) down -v
	$(foreach image,$(all_images),$(docker_bin) rmi -f $(image);)

---------------: ## ---------------

db-backup: up ## Backup mysql database to PROJECT_DIR/backup.sql
	$(docker_compose_bin) exec "$(SQL_CONTAINER_NAME)" /usr/bin/mysqldump --add-drop-table -u "$(SQL_USER)" --password="$(SQL_PASS)" "$(SQL_DB)" | sed '/mysqldump: \[Warning\] Using a password/d' > $(VALERKA_CONFIG_DIR)/src/backup.sql

db-restore: ## Restore mysql database from PROJECT_DIR/backup.sql
	cat $(VALERKA_CONFIG_DIR)/src/backup.sql | $(docker_compose_bin) exec -T "$(SQL_CONTAINER_NAME)" /usr/bin/mysql -u "$(SQL_USER)" --password="$(SQL_PASS)" "$(SQL_DB)"

---------------: ## ---------------
add: ## Add new project to config
	@$(VALERKA_DIR)/lib.sh add
add-current: ## Add current dir to config
	$(VALERKA_DIR)/lib.sh add $(PWD)
set: status ## Set current project
	@$(VALERKA_DIR)/lib.sh set
set-current:
	@$(VALERKA_DIR)/lib.sh set $(PWD)
	@valerka status
status: ## Show current project
	@$(VALERKA_DIR)/lib.sh status
ls: ## Show project list
	@$(VALERKA_DIR)/lib.sh list

