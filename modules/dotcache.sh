dotcache(){
    local CACHEFOLDER="${HOME}/.cache"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} of ${CACHEFOLDER} ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
