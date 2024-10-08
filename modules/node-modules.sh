nodeModules() {
    # node_modules folders
    echo "=== clearing node_modules folders ==="
    echo "  - looking for node_modules folders in ${DEVELOPMENT_BASE_DIR}... "
    local NODE_MODULE_FOLDERS=$(
        find -E "${DEVELOPMENT_BASE_DIR}" -type d \
            -regex '^.*node_modules$' \
            -not -regex "${HOME}/\..*" \
            -not -regex "^.*node_modules.+"
    )
    echo "  - found node_modules folders:"
    IFS=$'\n' # make newlines the only separator
    for NODE_MODULE_FOLDER in ${NODE_MODULE_FOLDERS}; do
        echo "  - ${NODE_MODULE_FOLDER}"
    done
    local MODULESWERE_REMOVED=0
    echo "  - running 'rm -rf ' in each of the above"
    for NODE_MODULE_FOLDER in ${NODE_MODULE_FOLDERS}; do
        MODULESWERE_REMOVED=1
        local NODE_MODULE_SIZE=$(du -hs "${NODE_MODULE_FOLDER}" | cut -f1)
        printf "  - removing '${NODE_MODULE_FOLDER}' (${NODE_MODULE_SIZE}) ... "
        rm -rf "${NODE_MODULE_FOLDER}"
        echo "done"
    done
    unset IFS
    if [ ${MODULESWERE_REMOVED} -eq 1 ]; then
        addHint "- You will need to reinstall node modules in each of your projects"
    fi

}
