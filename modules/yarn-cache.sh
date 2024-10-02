yarnCache() {
    # yarn cache
    command -v yarn >/dev/null 2>&1 && {
        local YARNCACHEDIR=$(yarn cache dir)
        local YARNSIZE=$(du -hs ${YARNCACHEDIR} | cut -f1)
        echo "=== removing yarn cache ${YARNCACHEDIR} (${YARNSIZE}) ==="
        yarn cache clean
    }
}
