cargoCaches() {
    # cargo cache
    command -v cargo >/dev/null 2>&1 && {
        if [ -d ${HOME}/.cargo/registry ]; then
            local CARGO_CACHE_SIZE=$(du -hs ${HOME}/.cargo/registry)
            echo "=== removing Cargo registry (${CARGO_CACHE_SIZE}) ==="
            rm -rf ${HOME}/.cargo/registry
        fi

        # search the development folder for "Cargo.lock" files, and run "cargo clean"
        #  where we find them

        local CARGO_LOCKFILES=$(
            find -E "${DEVELOPMENT_BASE_DIR}" -type f -name Cargo.lock \
                -not -regex "^.*node_modules.+"
        )
        echo "  - found cargo lock files; cleaning related 'target' folders..."
        IFS=$'\n' # make newlines the only separator
        local MODULESWERE_REMOVED=0

        for CARGO_LOCKFILE in ${CARGO_LOCKFILES}; do
            MODULESWERE_REMOVED=1
            local CARGO_FOLDER=$(dirname ${CARGO_LOCKFILE})
            local TARGET="${CARGO_FOLDER}/target"
            if [ -d ${TARGET} ]; then
                local TARGET_SIZE=$(du -hs "${TARGET}" | cut -f1)
                printf "  - removing '${TARGET}' (${TARGET_SIZE}) ... "
                rm -rf "${TARGET}"
                echo "done"
            fi
        done
        unset IFS
        if [ ${MODULESWERE_REMOVED} -eq 1 ]; then
            addHint "- You will need to re-run cargo in each of your projects"
        fi
    } || {
	    echo "=== 'cargo' command not found; continuing... ==="

    }
}
