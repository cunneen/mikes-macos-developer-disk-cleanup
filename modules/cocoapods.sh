cocoapods() {
    if [ -d ${HOME}/.cocoapods ]; then
        # Pods folders
        echo "=== clearing Pods folders ==="
        pod cache clean --all
        echo "  - looking for Pods folders in ${DEVELOPMENT_BASE_DIR}... "
        local PODS_FOLDERS=$(
            find -E "${DEVELOPMENT_BASE_DIR}" -type d \
                -regex '^.*Pods$' \
                -not -regex "${HOME}/\..*" \
                -not -regex "^.*Pods.+"
        )
        echo "  - found Pods folders:"
        IFS=$'\n' # make newlines the only separator
        for PODS_FOLDER in ${PODS_FOLDERS}; do
            echo "  - ${PODS_FOLDER}"
        done
        echo "  - running 'rm -rf ' in each of the above"
        local PODS_WERE_REMOVED=0
        for PODS_FOLDER in ${PODS_FOLDERS}; do
            PODS_WERE_REMOVED=1
            local PODS_FOLDER_SIZE=$(du -hs "${PODS_FOLDER}" | cut -f1)
            printf "  - removing '${PODS_FOLDER}' (${PODS_FOLDER_SIZE}) ... "
            rm -rf "${PODS_FOLDER}"
            echo "done"
        done
        unset IFS
        if [ ${PODS_WERE_REMOVED} -eq 1 ]; then
            addHint "- You'll need to perform a 'pod install' (or npx pod-install) in each of your projects"
        fi
    fi
}
