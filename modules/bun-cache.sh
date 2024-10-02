bunCache() {
    # bun cache
    if [ -d ${HOME}/.bun/install/cache ]; then
        local BUNSIZE=$(du -hs ${HOME}/.bun/install/cache | cut -f1)
        echo "=== removing bun cache...(${BUNSIZE}) ==="
        rm -rf ${HOME}/.bun/install/cache
    fi # bun cache
}
