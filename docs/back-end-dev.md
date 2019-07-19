# For develop Laravel back-end

## For start work in new project

```shell
cd LARAVEL_PROJECT_DIR
valerka init
```

### Open in browser [http://localhost](http://localhost)

---

## Run PHP Unit tests

```bash
valerka test
```

## Run cleaning test database

```bash
valerka test-clean
```

## Run artisan commands

Use `valerka shell` it's environment of application

```bash
valerka shell

php artisan list
php artisan cache:clean
```

## Backup mysql

Backup mysql database to PROJECT_DIR/backup.sql

```bash
valerka db-backup
```

## Restore mysql

Restore mysql database from PROJECT_DIR/backup.sql

```bash
valerka db-restore
```

## Install composer and JS requarements

If you need execute `npm install` or `composer install`

```shell
valerka install
```

## Build JS assets

```shell
valerka npm
```

---

## How to work with `composer`, `php`, `artisan`

```bash
valerka shell
```

## How to work with `npm`, `yarn`

```bash
valerka shell-node
```

---

## Speed up you work

In `valerka shell` available aliases:

| alias   | command               |
| ------- | --------------------- |
| art     | php artisan           |
| c       | composer              |
| phpunit | ./vendor/bin/phpunit  |
| tinker  | php artisan tinker    |

### example

```bash
valerka shell

art cache:clear
art config:clear

c install
```


## Recreate project from zero

```bash
valerka clean-project
valerka init
```