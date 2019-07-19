# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][keepachangelog] and this project adheres to [Semantic Versioning][semver].

-----------------------

## v2.0.0

### Added

- Replacement database acceses in `.env` file.
- Added project changing
- Removed hardcode envarioment variables from `docker-compose.yml`
- Added npm run in in different modes
- Added TL;DR to README.md

[keepachangelog]:https://keepachangelog.com/en/1.0.0/
[semver]:https://semver.org/spec/v2.0.0.html

## v2.1.0

- Translated to English
- Added highliting

## v2.2.0

- Added colorized text
- Added command to start shell into NodeJS and MySQL container
- Added creatring file 'version' on `make init`
- Added php module zip
- Fix npm run prod to production
- Fix path for container "test" in docker-compose.yml

## v2.3.0

- `make set` now down previous project and up current.
- Fix bug with no downloading image on nginx config.
- Increased max upload file size to 512Mb.

## v2.3.5

- Set artisan queue:work --tries=3
- Removed `APP_ENV` and `APP_DEBUG` from docker-compose.yml
- Fix creating file `version`
- `make test` run with env variable APP_ENV=test

## v2.4.0

- Added composer dump-autoload to `make start`
- Updated docker image nodeJS to v11
- Added yarn to node image
- Changed shell from sh to bash on `make shell`
- Fix `make test-clear`
- Updated Nginx config. Added routing cached static files to Laravel.

## v2.5.0

- Added valerka as a program
- Added valerka installer
- (Update) `make valerka-install`. Added `make valerka-update`
- (Update) `valerka init` add current dir as a project and init it
- (update) Added mysql client to app docker image
- (update) Added rsync to app image
- (update) Upper max upload file size to 512Mb and max post size 256Mb
- (update) Added highligh for messge in valerka install
- (update) Added `valerka stop-all` for stop all docker containers
- (update) Added zsh autocomplete
- (update) Added bash auto complete
- (update) Added function `valerka add-current` for setup current dir
- (Update) Added removing program. Fix path installing. Added checks
- (Update) Added config path `~/.valerka/` for work in user space
- (update) Added troubleshooting to Readme.md
- (update) Added new Hello for node-shel
- (fix) Added config.cnf migration
- (fix) Clean Makefile
- (fix) valerka work dir in docker-compose.yml
- (fix) src if is not link