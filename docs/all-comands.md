Here are just a few of them:

Command signature        | Description
------------------------ | -----------
`valerka help`            | Show this help
`valerka docker-install`  | Install docker to machine
`valerka check-update`    | Check update valerka
`valerka valerka-install` | Install valerka to machine
`valerka valerka-update`  | Update valerka in machine
`valerka valerka-remove`  | Uninstall valerka to machine
------------------------ | ---------------
`valerka app-pull`        | Application - pull latest Docker image (from remote registry)
`valerka app`             | Application - build Docker image locally
`valerka app-push`        | Application - tag and push Docker image into remote registry
`valerka node-pull`       | Node JS - pull latest Docker image (from remote registry)
`valerka node`            | Node JS - build Docker image locally
`valerka node-push`       | Node JS - tag and push Docker image into remote registry
`valerka sources-pull`    | Sources - pull latest Docker image (from remote registry)
`valerka sources`         | Sources - build Docker image locally
`valerka sources-push`    | Sources - tag and push Docker image into remote registry
`valerka nginx-pull`      | Nginx - pull latest Docker image (from remote registry)
`valerka nginx`           | Nginx - build Docker image locally
`valerka nginx-push`      | Nginx - tag and push Docker image into remote registry
`valerka pull`            | Pull all Docker images (from remote registry)
`valerka build`           | Build all Docker images
`valerka push`            | Tag and push all Docker images into remote registry
`valerka login`           | Log in to a remote Docker registry
------------------------ | ---------------
`valerka up`              | Start all containers (in background) for development
`valerka start`           | Start all containers (in background) for development and clear cache
`valerka down`            | Stop and delete all started for development containers
`valerka stop`            | Stop all started for development containers
`valerka restart`         | Restart all started for development containers
`valerka stop-all`        | Stop all Docker containers in machine
`valerka ps`              | List containers
------------------------ | ---------------
`valerka shell`           | Start shell into application container
`valerka shell-node`      | NodeJS container start shell
`valerka shell-mysql`     | MySQL container start shell
------------------------ | ---------------
`valerka install`         | Install Laravel dependencies (npm install; composer install)
`valerka remove-dep`      | Remove application dependencies
`valerka reinstall`       | Reinstall application dependencies into application container
`valerka fix-env`         | Create .env file from .env.example and fix аccesses
------------------------ | ---------------
`valerka watch`           | Start watching assets for changes (node)
`valerka npm`             | Start run the bundled code in "production" mode
`valerka npm-dev`         | Start run the bundled code in "development" mode
------------------------ | ---------------
`valerka init`            | Make full application initialization (install, seed, build assets, etc)
------------------------ | ---------------
`valerka test`            | Execute application tests
`valerka test-clean`      | Clean database testme
------------------------ | ---------------
`valerka clean-docker`    | Remowe unused docker cache
`valerka clean-project`   | Remove nmp and composer modules, docker images from local registry
------------------------ | ---------------
`valerka db-backup`       | Backup mysql database to $(VALERKA_CONFIG_DIR)/src/backup.sql
`valerka db-restore`      | Restore mysql database from $(VALERKA_CONFIG_DIR)/src/backup.sql
------------------------ | ---------------
`valerka add`             | Add new project to config
`valerka add-current`     | Add current dir to config
`valerka set`             | Set current project
`valerka status`          | Show current project
`valerka ls`              | Show project list