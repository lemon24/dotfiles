#!/bin/bash
#
# usage: ./run.sh command [argument ...]
#
# See https://death.andgravity.com/run-sh for how this works.

set -o nounset
set -o pipefail
set -o errexit


ROOT=${0%/*}
if [[ $0 != $ROOT && $ROOT != "" ]]; then
    cd "$ROOT"
fi
readonly ROOT=$( pwd )


function install {
    install-sh
    install-zsh 
    install-xonsh 
    install-direnv 
    install-kate
}

function install-sh {
    rm -f ~/.shrc
    ln -s $ROOT/shrc ~/.shrc
}

function install-zsh {
    rm -f ~/.zshrc
    ln -s $ROOT/zshrc ~/.zshrc
}

function install-xonsh {
    rm -f ~/.xonshrc
    ln -s $ROOT/xonshrc ~/.xonshrc
}

function install-direnv {
    rm -f ~/.config/direnv/direnvrc
    ln -s $ROOT/direnvrc ~/.config/direnv/direnvrc
}

readonly AS="$HOME/Library/Application Support"
readonly PS="$HOME/Library/Preferences"

function install-kate {
    mkdir -p "$AS/org.kde.syntax-highlighting/themes"
    ln -sf $ROOT/kate/themes/* "$AS/org.kde.syntax-highlighting/themes"
    
    mkdir -p "$AS/katepart5"
    rm -rf "$AS/katepart5/syntax"
    ln -s $ROOT/kate/syntax "$AS/katepart5/syntax"
    
    rm -f "$PS/katemoderc"
    ln -s $ROOT/kate/katemoderc "$PS/katemoderc"

    # set default [Kate Plugins], no need to sync
    mv "$AS/kate/anonymous.katesession" "$AS/kate/anonymous.katesession.old" || true
    $ROOT/kate/rc.py merge \
        $ROOT/kate/anonymous.katesession \
        "$AS/kate/anonymous.katesession.old" \
    > "$AS/kate/anonymous.katesession"

    # sync by dump-kate
    mv "$PS/katerc" "$PS/katerc.old" || true
    $ROOT/kate/rc.py merge "$PS/katerc.old" $ROOT/kate/katerc > "$PS/katerc"
    
}

function dump-kate {
    $ROOT/kate/rc.py dump "$PS/katerc" > $ROOT/kate/katerc
}



"$@"


