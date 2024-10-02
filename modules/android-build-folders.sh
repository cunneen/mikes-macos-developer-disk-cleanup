androidBuildFolders() {
    # Android projects - remove build folders
    if [ -d ${HOME}/.android ]; then
        echo "=== clearing android build folders ==="
        echo "  - looking for android manifest files in ${DEVELOPMENT_BASE_DIR}... "
        local ANDROID_MANIFESTS=$(
            find -E "${DEVELOPMENT_BASE_DIR}" -type f \
                -regex '^.*/src/main/AndroidManifest.xml' \
                -not -regex '^.*/debug/.*' \
                -not -regex "^.*build/.*" \
                -not -regex "^.*/node_modules/.*" |
                sed -E 's/\/src\/main\/AndroidManifest.xml//'
        )
        echo "  - found manifests in: ${ANDROID_MANIFESTS}"
        IFS=$'\n' # make newlines the only separator
        for ANDROID_FOLDER in ${ANDROID_MANIFESTS}; do
            if [ -d "${ANDROID_FOLDER}/build" ]; then
                BUILDSIZE=$(du -hs "${ANDROID_FOLDER}/build" | cut -f1)

                printf "  - removing ${ANDROID_FOLDER}/build (${BUILDSIZE})..."
                rm -rf "${ANDROID_FOLDER}/build"
                echo "done"
            fi
        done
        unset IFS
    fi
}
