mobilesmstmp(){
    local CACHEFOLDER="${HOME}/Library/Containers/com.apple.MobileSMS/Data/tmp"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} of MobileSMS temp files ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
