androidSDK() {
    local THISMODULEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    # Android SDK Manager Cleanup
    command -v ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager >/dev/null 2>&1 && {
        local SDKMANAGER_COMMAND="${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager"
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

        local SDKMANAGER_OUTPUT=$(${SDKMANAGER_COMMAND} --list_installed --include_obsolete)

        echo "${SDKMANAGER_OUTPUT}" |
            awk -f "${THISMODULEDIR}/android-sdk.awk" -v outputFile="${OUTFILENAME}"

        if [ $? -ne 0 ]; then
            echo "    WARNING: we could not parse the output of 'sdkmanager --list_installed --include_obsolete'"
            echo "    \(very likely there is just nothing to remove\)"
            cat "${OUTFILENAME}"
            return 100
        fi

        echo "    - packages to remove: "
        cat "${OUTFILENAME}" | sed 's/^/      - /'

        echo "    - uninstalling packages..."
        ${SDKMANAGER_COMMAND} --uninstall --package_file="${OUTFILENAME}"
        local ANDROIDHOME_AFTER=$(du -hs $ANDROID_HOME | cut -f1)

        echo "  - BEFORE ANDROID SDKMANAGER CLEANUP: ${ANDROIDHOME_BEFORE} (${ANDROID_HOME})"
        echo "  - AFTER ANDROID SDKMANAGER CLEANUP: ${ANDROIDHOME_AFTER}"
        addHint "- You may need to run android's SDK manager to restore the Android SDK versions you were using"
    } || {
        echo "'${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager' command not found"
        return 1
    }
}
