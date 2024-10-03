androidSDK() {
    local THISMODULEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    # Android SDK Manager Cleanup
    command -v ${ANDROID_HOME}/tools/bin/sdkmanager >/dev/null 2>&1 && {

        local ANDROIDHOME_BEFORE=$(du -hs $ANDROID_HOME | cut -f1)

        echo "=== android sdkmanager cleanup ==="
        echo "  - BEFORE CLEANUP: ${ANDROIDHOME_BEFORE} (${ANDROID_HOME})"

        # remove .downloadIntermediates folder if it exists
        if [ -d "${ANDROID_HOME}/.downloadIntermediates" ]; then
            echo "    - removing ${ANDROID_HOME}/.downloadIntermediates"
            rm -rf "${ANDROID_HOME}/.downloadIntermediates"
        fi
        # create temporary output file
        local OUTFILENAME=$(mktemp)

        local SDKMANAGER_OUTPUT=$(sdkmanager --list_installed --include_obsolete)
        echo "${SDKMANAGER_OUTPUT}" |
            awk -f "${THISMODULEDIR}/android-sdk.awk" -v outputFile="${OUTFILENAME}"

        if [ $? -ne 0 ]; then
            echo "    WARNING: we couldn't parse the output of 'sdkmanager --list_installed --include_obsolete'"
            echo "    (very likely there's just nothing to remove)"
            return 100
        fi

        echo "    - packages to remove: "
        cat "${OUTFILENAME}" | sed 's/^/      - /'

        echo "    - uninstalling packages..."
        sdkmanager --uninstall --package_file="${OUTFILENAME}"
        local ANDROIDHOME_AFTER=$(du -hs $ANDROID_HOME | cut -f1)

        echo "  - BEFORE ANDROID SDKMANAGER CLEANUP: ${ANDROIDHOME_BEFORE} (${ANDROID_HOME})"
        echo "  - AFTER ANDROID SDKMANAGER CLEANUP: ${ANDROIDHOME_AFTER}"
        addHint "- You may need to run android's SDK manager to restore the Android SDK versions you were using"
    } || {
        echo "'${ANDROID_HOME}/tools/bin/sdkmanager' command not found"
        return 1
    }
}
