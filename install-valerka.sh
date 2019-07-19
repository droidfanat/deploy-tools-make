#!/bin/bash

VALERKA_BIN_PATH=/usr/local/bin/valerka
VALERKA_INSTALL_PATH=/usr/local/etc/valerka

GIT_REPO='https://gitlab+deploy-token-4:zA1o4PV6uGUyp2eZxHq4@git.artjoker.ua/vinz/valerka.git'

source ./lib.sh

green_text "Requires sudo permissions"
sudo true

remove-valerka(){
    if [ -L $VALERKA_BIN_PATH ] || [ -f $VALERKA_BIN_PATH ]; then
        sudo rm $VALERKA_BIN_PATH
    fi

    if [ -d $VALERKA_INSTALL_PATH ]; then
        sudo rm -rf $VALERKA_INSTALL_PATH
    fi
    green_text 'Valerka removed from PC'
}

install-valerka(){
    if [ ! -d /usr/local/etc/valerka/ ]; then
        sudo mkdir -p /usr/local/etc/valerka/
    fi

    sudo cp -R ${PWD}/. /usr/local/etc/valerka/

    sudo ln -sfn /usr/local/etc/valerka/valerka.sh /usr/local/bin/valerka

    if [ ! -d "${HOME}/.valerka/" ]; then
        mkdir -p "${HOME}/.valerka/"
    fi

    touch "$CONFIG_FILE"

    # Migration for old users
    if [ -z "$(cat $CONFIG_FILE)" ]; then
        if [ -f "${PWD}/config.cnf" ]; then
            cat "${PWD}/config.cnf" >> "$CONFIG_FILE"
        fi

        if [ -L "${PWD}/src" ]; then
            ln -sfn "$PWD/src" "$VALERKA_CONFIG_DIR/src"
        fi
    fi

    # Change git repo
    if [ -f $VALERKA_INSTALL_PATH/.git/config ]; then
       sudo sed -i "s#git@git.artjoker.ua:vinz/valerka.git#${GIT_REPO}#g" "$VALERKA_INSTALL_PATH/.git/config"
    fi 

    green_text "
    valerka seccusful installed"
    
}

install-zsh-autocomplete(){
    
    if [ -d ~/.oh-my-zsh ]; then
        if [ ! -d ${HOME}/.oh-my-zsh/completions ]; then 
            mkdir -p ${HOME}/.oh-my-zsh/completions
            chmod 755 ${HOME}/.oh-my-zsh/completions/
        fi
    
        if [ ! -f ${HOME}/.oh-my-zsh/completions/_valerka-zsh ]; then
            ln -sfn /usr/local/etc/valerka/autocomplete/_valerka-zsh ${HOME}/.oh-my-zsh/completions/_valerka-zsh
        fi
    else
        if [ -d /usr/local/share/zsh/site-functions/ ]; then
            sudo ln -sfn /usr/local/etc/valerka/autocomplete/_valerka-zsh /usr/local/share/zsh/site-functions/_valerka-zsh
        else
            red_text 'false installing zsh autocomplete '
        fi
    fi
    zsh -c 'rm -f ~/.zcompdump; autoload -Uz compinit'

    green_text "
    zsh autocomplete seccusful installed"

    }


install-bash-autocomplete(){
    if grep -q '# valerka autocomplete' ~/.bashrc; then
        sed -i '\|# valerka autocomplete| {N;s|\n.*|\n source /usr/local/etc/valerka/autocomplete/valerka-bash|}' ~/.bashrc

    else
        echo "
# valerka autocomplete
    source /usr/local/etc/valerka/autocomplete/valerka-bash
        " >> ~/.bashrc
    fi

    green_text "
    bash autocomplete seccusful installed"
}

main(){
    remove-valerka

    install-valerka

if [ -f ~/.zshrc ]; then
    install-zsh-autocomplete
fi

    install-bash-autocomplete

}


case "$1" in
    remove)
        remove-valerka
    ;;
    *) 
        main
esac
