# remove everything in ~/Library/Caches
libraryCaches() {
    local LIBRARYCACHESIZE=$(du -hs "${HOME}/Library/Caches" | cut -f1)
    echo "=== emptying ~/Library/Caches...(${LIBRARYCACHESIZE}) ==="
    rm -rf "${HOME}/Library/Caches"    
}
