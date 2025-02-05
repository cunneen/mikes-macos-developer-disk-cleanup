androidAVD() {
    # Android Virtual Device Cleanup
    local AVDMANAGER=${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager
    command -v ${AVDMANAGER} >/dev/null 2>&1 && {
        # get the full path from one of the AVDs
        local FIRST_AVD_PATH=$(${AVDMANAGER} list avd | grep  "Path:" | head -1 | tr -s " "| cut -f3 -d" ")

        if [ -z "${FIRST_AVD_PATH}" ]; then
            echo "no avds found"
            return 0
        fi

        # get the parent folder
        local FIRST_AVD_PARENTPATH=$(dirname "${FIRST_AVD_PATH}")
        local AVDFOLDERSIZEBEFORE=$(du -hs "${FIRST_AVD_PARENTPATH}" | cut -f1)
        echo "=== removing avds from ${FIRST_AVD_PARENTPATH} (${AVDFOLDERSIZEBEFORE}) ==="
        for AVD in $(${AVDMANAGER} list avd -c); do
            printf "    - deleting AVD %s ..."
            ${AVDMANAGER} delete avd -n "${AVD}"
            echo "done"
        done
        local AVDFOLDERSIZEAFTER=$(du -hs "${FIRST_AVD_PARENTPATH}" | cut -f1)
        echo "    AVD folder size before: ${AVDFOLDERSIZEBEFORE}; after: ${AVDFOLDERSIZEAFTER}"
    } || {
        echo "'${AVDMANAGER}' command not found"
        return 1
    }
}
