androidSDK() {
    local THISMODULEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    # Android SDK Manager Cleanup
    command -v sdkmanager >/dev/null 2>&1 && {

        local ANDROIDHOME_BEFORE=$(du -hs $ANDROID_HOME | cut -f1)

        echo "=== android sdkmanager cleanup ==="
        echo "  - BEFORE CLEANUP: ${ANDROIDHOME_BEFORE} (${ANDROID_HOME})"

        # create temporary output file
        local OUTFILENAME=$(mktemp)

        sdkmanager --list_installed --include_obsolete |
            awk -f "${THISMODULEDIR}/android-sdk.awk" -v outputFile="${OUTFILENAME}"

        if [ $? -ne 0 ]; then
            echo "    WARNING: we couldn't parse the output of 'sdkmanager --list_installed --include_obsolete'"
            echo "    (maybe there's just nothing to remove?)"
            return 1
        fi

        echo "    - packages to remove: "
        cat "${OUTFILENAME}" | sed 's/^/      - /'

        echo "    - uninstalling packages..."
        sdkmanager --uninstall --package_file="${OUTFILENAME}"
        local ANDROIDHOME_AFTER=$(du -hs $ANDROID_HOME | cut -f1)

        echo "  - BEFORE CLEANUP: ${ANDROIDHOME_BEFORE} (${ANDROID_HOME})"
        echo "  - AFTER CLEANUP: ${ANDROIDHOME_AFTER}"
    } || {
        echo "'sdkmanager' command not found"
        return 1
    }
}
