#!/usr/bin/env bash
set +x

program_dir(){
    SOURCE="${BASH_SOURCE[0]}"

    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done

    echo "$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
}

VALERKA_DIR=$(program_dir)

VALERKA_CONFIG_DIR=${HOME}/.valerka

CONFIG_FILE=${VALERKA_CONFIG_DIR}/config.cnf

bold_text(){
    echo -e '\033[1m'"$@"'\033[0m'
}

green_text() {
    echo -e '\033[32m'"$@"'\033[0m'	
}

red_text() {
    echo -e '\033[1;31m'"$@"'\033[0m'
}



read_config(){
    source $CONFIG_FILE
}

fix_project_list(){
    # Remove slash '/' in and of path in config file
    awk -i inplace -F ":" '{gsub(/\/$/,"")}; {print}' $CONFIG_FILE
    # Sort config and remove duplicat. Rewrite config
    sort -u -o $CONFIG_FILE $CONFIG_FILE
}

project_list(){
    PROJECTS_LIST=( $(awk -F ":" '{print $1}' $CONFIG_FILE) )
    PROJECT_NAME=$(basename $(readlink -f $VALERKA_CONFIG_DIR/src))
    
    echo
    for PROJECT in ${PROJECTS_LIST[@]}; do
        if [ "$PROJECT" ==  "$PROJECT_NAME" ]; then
            green_text $(bold_text $PROJECT) $(green_text "<- current")
        else
            green_text "$(bold_text $PROJECT)"
        fi

    done
}

set_project(){
    if [ ! -z "$1" ]; then
        PROJECT_NAME="$1"
    else

        PROJECTS_LIST="$(awk -F ":" '{print $1}' $CONFIG_FILE)"
        PS3="
$(bold_text "Choose project number to set: ")"
        echo -e '\033[32m'
        select name in $PROJECTS_LIST; do
            PROJECT_NAME="$name"
        break
        done
        echo -e '\033[0m'
    fi

    PROJECT_PATH=$(grep -i "$PROJECT_NAME" "$CONFIG_FILE" | awk -F ":" '{print $2}')

    if [ -z "$PROJECT_PATH" ]; then
        red_text "No directory was found for $(bold_text $PROJECT_NAME)" 
        return 1
    fi
    
    if [ ! -d "$PROJECT_PATH" ]; then
        red_text "$(bold_text "$PROJECT_PATH") is not a directory"
        return 1
    fi
    valerka down
    
    # Fix  src if it not link
    if [ ! -L $VALERKA_CONFIG_DIR/src ]; then
        rmdir $VALERKA_CONFIG_DIR/src
    fi

    fix_project_list

    ln -sfn "$PROJECT_PATH" "$VALERKA_CONFIG_DIR/src"

    valerka up

    green_text "Project changed to $(bold_text $PROJECT_NAME)"
}


status(){
    PROJECT_NAME=$(basename $(readlink -f $VALERKA_CONFIG_DIR/src))

    PROJECT_PATH=$(readlink -f $VALERKA_CONFIG_DIR/src)
    echo
    green_text "Current project: $(bold_text $PROJECT_NAME)"
    green_text "In folder: $(bold_text $(readlink -f $VALERKA_CONFIG_DIR/src))"
}

add_project(){
    PATH_TO_PROJECT="$1"

    if [ -z "$PATH_TO_PROJECT" ]; then
        echo
        read -ep "$(green_text 'Enter path to project: ')" PATH_TO_PROJECT
        echo
    fi

    PATH_TO_PROJECT=$(echo "$PATH_TO_PROJECT" | sed s:^~:"$HOME":)
    
    if [ -f "$CONFIG_FILE" ]; then
        # If path not exist in config - add to config
        if ! awk -F ":" '{print $2}' $CONFIG_FILE | grep -E "^$PATH_TO_PROJECT$"; then

            if [ ! -d "$PATH_TO_PROJECT" ] ; then
                red_text "$(bold_text $PATH_TO_PROJECT) not a directory"
                return 1
            fi

            PROJECT_NAME=$(basename "$PATH_TO_PROJECT")

            echo "$PROJECT_NAME:$PATH_TO_PROJECT" >> "$CONFIG_FILE"

            fix_project_list

            set_project "$PROJECT_NAME"

            echo
            green_text "Added and set current project $(bold_text $PROJECT_NAME)"
        fi
    fi
}

case "$1" in
    program_dir)
        program_dir
    ;;
    add)
        add_project "$2"
    ;;
    set|setup)
        set_project "$(basename "$2")"
    ;;
    status)
        status
    ;;
    list)
        echo
        green_text 'Available projects:'
        project_list
    ;;
esac
