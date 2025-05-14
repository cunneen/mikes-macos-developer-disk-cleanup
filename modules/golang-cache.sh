goCaches() {
    # go cache
    command -v go >/dev/null 2>&1 && {
        # Go Build Cache
        local GOBUILD_CACHE=$(go env GOCACHE);
        # Go module download cache
        local GOMOD_CACHE=$(go env GOMODCACHE);

        if [ -d "${GOBUILD_CACHE}" ]; then
            local GOBUILD_CACHE_SIZE=$(du -hs ${GOBUILD_CACHE});
            echo "=== removing Go Build Cache (${GOBUILD_CACHE_SIZE}) ==="
            go clean -cache
        fi

        if [ -d "${GOMOD_CACHE}" ]; then
            local GOMOD_CACHE_SIZE=$(du -hs ${GOMOD_CACHE});
            echo "=== removing Go Module Cache (${GOMOD_CACHE_SIZE}) ==="
            go clean -modcache
        fi
    } || {
	    echo "=== 'go' command not found; continuing... ==="
    }
}
