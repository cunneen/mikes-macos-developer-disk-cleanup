yarnCache() {
    # yarn cache
    command -v yarn >/dev/null 2>&1 && {
        yarn set version classic
        local YARNCACHEDIR=$(yarn cache dir)
        local YARNSIZE=$(du -hs ${YARNCACHEDIR} | cut -f1)
        echo "=== removing yarn 'classic' cache ${YARNCACHEDIR} (${YARNSIZE}) ==="
        yarn cache clean
        yarn set version berry
        YARNCACHEDIR=$(yarn config get cacheFolder)
        YARNSIZE=$(du -hs ${YARNCACHEDIR} | cut -f1)
        echo "=== removing yarn 'berry' cache ${YARNCACHEDIR} (${YARNSIZE}) ==="
        yarn cache clean
    } || {
	    echo "=== 'yarn' command not found; continuing... ==="
    }
}
