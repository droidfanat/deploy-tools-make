# For understanding

Valerka based on project
[Docker + Laravel = ❤](https://habr.com/post/425101/)

## How to update image

After edit image in the `docker` directory:

Find in [servers](https://docs.google.com/spreadsheets/d/1NVy8BEDHxKko92hSEZ305ftf2VJnHoQok10SWWLdzXk/edit#gid=949215248)
Login and password from hub.docker.com

### Login to docker hub

```shell
docker login hub.docker.com
```

### Build and push image

|                      |                                                              |
| -------------------- | ------------------------------------------------------------ |
| `valerka app-push`   | Application - tag and push Docker image into remote registry |
| `valerka node-push`  | Node JS - tag and push Docker image into remote registry     |
| `valerka nginx-push` | Nginx - tag and push Docker image into remote                |

## How to customize nginx redirects in Laravel project

Create file

```bash
touch LARAVEL_PROJECT_DIR/docker/nginx/etc/redirects.conf
```

And edit this file.

File redirects.conf included to general nginx.conf

## How it work

Path to project and project name stored in a file `~/.valerka/config.cnf`

File `~/.valerka/src` is a link to current project.

Project name is a `basename` from path to project

Example:

```bash
basename $HOME/Projects/orb
```

Result:

```shell
orb
```

Docker configuration stored in `valerka/docker-compose.yml`

Everything is built around:
`docker-compose -p project_name up`

Where flag `-p project_name` create docker volumes and containers with prefix `project_name`

Check this

`docker-compose -p project_name ps`

`docker volume ls`

### What do `valerka init`

- Start docker environment
- composer install
- npm install
- If file `.env` not exist - create them from `.env.example`
- Replace accesses to MySQL and Redis on file `.env`
- Fresh migrate and seed DB `homestead` and `testme`
- Generate app key
- npm run prod

---

### Project folder structure

|                     |                        |
| ------------------- | ---------------------- |
| Installation folder | /usr/local/etc/valerka |
| Config folder       | ~/.valerka             |
| Executable file     | /usr/local/bin/valerka |

#### Config folder

```shell
~/.valerka                          # folder with config
├── config.cnf                      # list of projects and path
└── src -> /home/vinz/Projects/orb  # simlink to current active project
```

#### Installation folder

```shell
├── autocomplete        # dir with autocomplite files
│   ├── valerka-bash    # bash autocomplite
│   └── _valerka-zsh    # zsh autocomplite
├── CHANGELOG.md
├── docker              # Dockerfiles and configs for building images
│   ├── app             # Files for app image
│   │   ├── aliases     # aliases for bash
│   │   │   ├── art     # alias for artisan
│   │   │   ├── artisan
│   │   │   ├── c       # alias for composer
│   │   │   ├── ll      # alias for ls -l
│   │   │   ├── phpunit # alias for start phpunit tests
│   │   │   └── tinker  # alias for php artisan tinker
│   │   ├── Dockerfile  # How to build php app docker image
│   │   ├── etc         # configs for php
│   │   │   └── php
│   │   │       ├── php-fpm.conf
│   │   │       └── php.ini
│   │   ├── fpm-entrypoint.sh   # sript for run container as php-fpm server
│   │   ├── keep-alive.sh       # sript for run container as app container
│   │   └── scheduler.sh        # sript for run container as scheduler worker
│   ├── init.sql                # file for bootstrap mysql with DB 'testme' for phpunit
│   ├── nginx                   # Files for nginx image
│   │   ├── Dockerfile          # How to build nginx docker image
│   │   ├── etc                 # Nginx configs
│   │   │   ├── errorpages.conf # Custom error pages
│   │   │   ├── fastcgi_params  # PHP-FPM config for nginx
│   │   │   ├── html            # default site files
│   │   │   ├── html-errorpages # custom error pages in html
│   │   │   └── nginx.conf      # General nginx config
│   │   └── nginx-entrypoint.sh # Script for run nginx with seted variabels
│   ├── node            # Files for nodeJS image
│   │   └── Dockerfile  # How to build node docker image
│   ├── sources         # Files for production image with php-fpm and nginx
│   │   └── Dockerfile  # How to build production docker image
├── docker-compose.yml  # General for docker-compose
├── docs
│   ├── all-comands.md
│   ├── back-end-dev.md
│   ├── devops.md
│   ├── front-end-dev.md
│   └── images
├── install-valerka.sh # Bash install
├── lib.sh             # Bash functions for Makefile
├── Makefile           # General file for run Valerka tasks
├── README.md
├── scripts                 # Helpful bash scripts
│   ├── docker-install.sh   # Install docker to local machine
│   ├── check_for_update.sh # Check valerka update
│   └── update.sh           # Valerka update
└── valerka.sh              # Entrypoint
```