#!/usr/bin/env bash

function current_linux_time() {
  echo $(( $(date +%s) / 60 / 60 / 24 ))
}

function update_valerka_update() {
  echo "LAST_EPOCH=$(current_linux_time)" > ${VALERKA_CONFIG_DIR}/.valerka-update
}

function upgrade_valerka() {
  bash ${VALERKA_DIR}/scripts/update.sh
  # update date of last update
  update_valerka_update
}

epoch_target=${UPDATE_VALERKA_DAYS:-14}

# Cancel upgrade if git is unavailable on the system
command -v git >/dev/null || return 0

if mkdir "$VALERKA_CONFIG_DIR/update.lock" 2>/dev/null; then
  if [ -f ${VALERKA_CONFIG_DIR}/.valerka-update ]; then
    source ${VALERKA_CONFIG_DIR}/.valerka-update

    if [[ -z "$LAST_EPOCH" ]]; then
      update_valerka_update && return 0
    fi

    epoch_diff=$(($(current_linux_time)-$LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]; then
      if [ "$DISABLE_UPDATE_PROMPT" = "true" ]; then
        upgrade_valerka
      else
        printf '%s' "$(tput setaf 2)" "[Valerka] Would you like to update? [Y/n]:" "$(tput sgr0)"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
          upgrade_valerka
        else
          update_valerka_update
        fi
      fi
    fi
  else
    # create the zsh file
    update_valerka_update
  fi

  rmdir ${VALERKA_CONFIG_DIR}/update.lock
fi


