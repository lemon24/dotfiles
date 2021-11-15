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
    install-direnv
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
    mkdir -p ~/.config/direnv
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

function install-display-overrides {
    # https://forums.macrumors.com/threads/guide-fixing-external-monitor-scaling-and-fuzziness-issues-with-mbp-and-osx.2179968/
    # https://codeclou.github.io/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions/

    # for macOS versions newer than Catalina, see https://github.com/waydabber/BetterDummy

    local version=$(
        sw_vers | awk '/ProductVersion/ { print $2 }' | cut -d. -f-2
    )
    if [[ $version != "10.15" ]]; then
        echo "this only works on Catalina"
        return
    fi

    if [[ $(
        defaults read \
            /Library/Preferences/com.apple.windowserver.plist \
            DisplayResolutionEnabled
    ) != '1' ]]; then
        sudo defaults write \
            /Library/Preferences/com.apple.windowserver.plist \
            DisplayResolutionEnabled \
            -bool true
    fi

    for src in $ROOT/display-overrides/*/*; do
        local dst=/Library/Displays/Contents/Resources/Overrides/$(
            realpath --relative-to=$ROOT/display-overrides $src
        )
        if [[ ! -e $dst ]]; then
            echo copying $dst
            sudo cp $src $dst
        else
            echo have $dst
        fi
    done
}


"$@"


