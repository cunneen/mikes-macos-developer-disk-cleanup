logs(){
    local CACHEFOLDER="${HOME}/Library/Logs"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} of Logs ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
