
```
 ██╗   ██╗ █████╗ ██╗     ███████╗██████╗ ██╗  ██╗ █████╗
 ██║   ██║██╔══██╗██║     ██╔════╝██╔══██╗██║ ██╔╝██╔══██╗
 ██║   ██║███████║██║     █████╗  ██████╔╝█████╔╝ ███████║
 ╚██╗ ██╔╝██╔══██║██║     ██╔══╝  ██╔══██╗██╔═██╗ ██╔══██║
  ╚████╔╝ ██║  ██║███████╗███████╗██║  ██║██║  ██╗██║  ██║
   ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
```

# Valerka - easy launch Laravel projects in docker

## Installation

```bash
git clone https://git.artjoker.ua/vinz/valerka.git
cd valerka
make valerka-install
cd ../
rm -rf valerka
```

---


## Update

```bash
valerka valerka-update
```

---

## Start work with Laravel

```bash
cd NEW_PROJECT_DIR
valerka init
```

### The project is available by url

[http://localhost](http://localhost)

---

## [Instruction for front-end development](docs/front-end-dev.md)

[docs/front-end-dev.md](docs/front-end-dev.md)

---

## [Instruction for back-end development](docs/back-end-dev.md)

[docs/back-end-dev.md](docs/back-end-dev.md)

---

## [Instruction for DevOps](docs/devops.md)

[docs/devops.md](docs/devops.md)

---

## [Full command list](docs/all-comands.md)

[docs/all-comands.md](docs/all-comands.md)

---

# Work with several projects

## Add a new project and valerka it current

```bash
cd NEW_PROJECT_DIR
valerka init
```

## Change current project

```bash
valerka set
```

## Check current project

```bash
valerka status
```

## Stop work

```bash
valerka down
```

### Start work

```bash
valerka start
```

---

## System requirements

For local application starting (for development) valerka sure that you have locally installed next applications:

- `docker >= 18.0` _(install: `curl -fsSL get.docker.com | sudo sh`)_
- `docker-compose >= 1.22` _([installing manual][install_compose])_
- `make >= 4.1` _(install: `apt-get install make`)_

## Install docker

Install:

- Docker
- Docker-compose
- Dockstation

For **Ubuntu** you can use:

```bash
valerka docker-install
```

If you use another Linux:
    [https://docs.docker.com/install/#backporting](https://docs.docker.com/install/#backporting)

## Used services

This application uses next services:

- nginx
- PHP-FPM
- MySQL (data storage)
- Redis (cache, internal queue)

Use valerka for laravel in docker

For more information execute in your terminal `valerka help`.


## Troubleshooting

If you see error

```bash
Bind for 0.0.0.0:3306 failed: port is already allocated
```

execute
```
valerka stop-all
```

Stop and disable services:
 - mysql
 - redis
 - nginx
 - apache/httpd