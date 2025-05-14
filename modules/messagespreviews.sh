messagespreviews(){
    local CACHEFOLDER="${HOME}/Library/Messages/Caches"
    if [ -d "${CACHEFOLDER}" ]; then

        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} from Messages Preview cache ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
