homebrewCaches(){
    local BREW;
    if [ -f /opt/homebrew/bin/brew ]; then
        # apple silicon
        BREW=/opt/homebrew/bin/brew
    elif [ -f /usr/local/bin/brew ]; then
        # intel mac
        BREW=/usr/local/bin/brew
    else
        BREW=/home/linuxbrew/.linuxbrew/bin/brew
    fi
    # Homebrew Caches
    command -v ${BREW} >/dev/null 2>&1 && {
        echo "=== cleaning up homebrew caches ==="
        local SIZEBEFORE=$(du -hs ${HOME}/Library/Caches/Homebrew | cut -f1)
        # set +e: don't exit on error (brew cleanup sometimes has permissions problems)
        set +e
        ${BREW} cleanup --prune=all
        if [ $? -ne 0 ]; then
            echo "!!! failed to clean up homebrew caches !!!"
            echo "    check the output above for more info"
        fi
        # set -e: exit on error
        set -e
        local SIZEAFTER=$(du -hs ${HOME}/Library/Caches/Homebrew | cut -f1)
        echo "    cache size before: ${SIZEBEFORE}; after: ${SIZEAFTER}"
    } || {
	    echo "=== 'brew' command not found; continuing... ==="
    }
}
