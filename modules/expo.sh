expo(){
    local CACHEFOLDER="${HOME}/.expo/ios-simulator-app-cache"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} of Expo iOS Simulator App caches ==="
        rm -rf "${CACHEFOLDER}"
    fi
    CACHEFOLDER="${HOME}/.expo/android-apk-cache"
    if [ -d "${CACHEFOLDER}" ]; then
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing ${SIZEBEFORE} of Expo Android APK caches ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
