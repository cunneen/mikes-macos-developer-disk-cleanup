msteams(){
    local CACHEFOLDER="${HOME}/Library/Containers/com.microsoft.teams2/Data/Library/Application Support/Microsoft/MSTeams/EBWebView"
    if [ -d "${CACHEFOLDER}" ]; then

        echo "=== removing MS Teams Caches ==="
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "    SIZE BEFORE: ${SIZEBEFORE}..."
        rm -rf "${CACHEFOLDER}/WV2Profile_tfw/Service Worker/CacheStorage"
        rm -rf "${CACHEFOLDER}/WV2Profile_tfl/Service Worker/CacheStorage"
        local SIZEAFTER=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "    SIZE AFTER: ${SIZEAFTER}..."
    fi
}
