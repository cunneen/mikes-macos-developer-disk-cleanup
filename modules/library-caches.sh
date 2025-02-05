# remove everything in ~/Library/Caches
libraryCaches() {
    local LIBRARYCACHESIZE=$((du -hs "${HOME}/Library/Caches" | cut -f1 ) || echo "ERROR: COULD NOT RUN 'du'")
    echo "=== emptying ~/Library/Caches...(${LIBRARYCACHESIZE}) ==="
    rm -rf "${HOME}/Library/Caches" || echo "=== ERROR! COULD NOT empty ~/Library/Caches. Continuing. ==="
}
