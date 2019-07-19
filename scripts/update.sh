#!/bin/env bash

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

printf "${BLUE}%s${NORMAL}\n" "Updating valerka - dockerize app tool"

printf "${GREEN}%s${NORMAL}\n" "Requires sudo permissions"

sudo true

cd "$VALERKA_DIR" && \
sudo git reset --hard
if sudo git pull --rebase --stat
then

  printf '%s\n' ''
  printf '%s' "$GREEN"
  printf '%s\n' ' ██╗   ██╗ █████╗ ██╗     ███████╗██████╗ ██╗  ██╗ █████╗ '
  printf '%s\n' ' ██║   ██║██╔══██╗██║     ██╔════╝██╔══██╗██║ ██╔╝██╔══██╗'
  printf '%s\n' ' ██║   ██║███████║██║     █████╗  ██████╔╝█████╔╝ ███████║'
  printf '%s\n' ' ╚██╗ ██╔╝██╔══██║██║     ██╔══╝  ██╔══██╗██╔═██╗ ██╔══██║'
  printf '%s\n' '  ╚████╔╝ ██║  ██║███████╗███████╗██║  ██║██║  ██╗██║  ██║'
  printf '%s\n' '   ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝'
  printf '%s\n' ''
  printf "${BLUE}%s\n" "Nice! Valerka has been updated to the current version."
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
