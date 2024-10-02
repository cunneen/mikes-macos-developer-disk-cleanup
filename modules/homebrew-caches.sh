homebrewCaches(){
    # Homebrew Caches
    command -v brew >/dev/null 2>&1 && {
        echo "=== cleaning up homebrew caches ==="
        local SIZEBEFORE=$(du -hs ${HOME}/Library/Caches/Homebrew | cut -f1)
        # set +e: don't exit on error (brew cleanup sometimes has permissions problems)
        set +e
        brew cleanup --prune=all
        if [ $? -ne 0 ]; then
            echo "!!! failed to clean up homebrew caches !!!"
            echo "    check the output above for more info"
        fi
        # set -e: exit on error
        set -e
        local SIZEAFTER=$(du -hs ${HOME}/Library/Caches/Homebrew | cut -f1)
        echo "    cache size before: ${SIZEBEFORE}; after: ${SIZEAFTER}"
    }
}