mediaanalysisd(){
    local CACHEFOLDER="${HOME}/Library/Containers/com.apple.mediaanalysisd/Data/Library/Caches"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs ${HOME}/Library/Containers/com.apple.mediaanalysisd/Data/Library/Caches | cut -f1)
        echo "=== removing ${SIZEBEFORE} from mediaanalysisd Cache ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
