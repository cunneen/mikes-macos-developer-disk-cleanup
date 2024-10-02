meteorBuildsAndPackages() {
    # meteor
    if [ -d ${HOME}/.meteor ]; then
        echo "=== FOUND ${HOME}/.meteor ==="

        # Clean up meteor package cache
        echo "cleaning up meteor package cache..."
        npx meteor-cleaner --keep-scanned ${DEVELOPMENT_BASE_DIR} --yes

        # Look for meteor projects
        echo "looking for meteor projects in ${DEVELOPMENT_BASE_DIR}... "
        echo "   (this can take a while. If it takes too long, try setting "
        echo "    DEVELOPMENT_BASE_DIR to the base directory of your development projects)"
        local METEOR_PROJECTS=$(
            find -E "${DEVELOPMENT_BASE_DIR}" -type f \
                -regex '^.*\.meteor/release$' \
                -not -regex "${HOME}/\.meteor/.*" \
                -not -regex "^.*node_modules.*" |
                sed -E 's/\/\.meteor\/release$//'
        )
        echo "=== found meteor projects: ==="
        IFS=$'\n' # make newlines the only separator
        for METEOR_PROJECT in ${METEOR_PROJECTS}; do
            echo "  - ${METEOR_PROJECT}"
        done

        for METEOR_PROJECT in ${METEOR_PROJECTS}; do
            if [ -d "${METEOR_PROJECT}/.meteor/local" ]; then
                local METEORSIZE=$(du -hs "${METEOR_PROJECT}/.meteor/local" | cut -f1)

                printf "  - Removing .meteor/local in ${METEOR_PROJECT} (${METEORSIZE} MB)... "
                rm -rf "${METEOR_PROJECT}/.meteor/local"
                echo "done"
            else
                echo "  - ${METEOR_PROJECT}/.meteor/local does not exist; skipping"
            fi
        done
        unset IFS
    fi #meteor

}
