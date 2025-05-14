xcodeArtifacts() {
    local DEVELOPERDIR="${HOME}/Library/Developer"
    # ### XCode ###
    if [ -d ${DEVELOPERDIR}/Xcode ]; then
        echo "=== clearing Xcode folders ==="

        # Xcode DerivedData
        local DERIVEDDATADIR="${DEVELOPERDIR}/Xcode/DerivedData"
        if [ -d "${DERIVEDDATADIR}" ]; then
            local XCDDSIZE=$(du -hs "${DERIVEDDATADIR}" | cut -f1)
            echo "   removing Xcode DerivedData(${XCDDSIZE})..."
            rm -rf "${DERIVEDDATADIR}"
        fi

        # Xcode DeviceLogs
        local DEVICELOGDIR="${DEVELOPERDIR}/Xcode/DeviceLogs"
        if [ -d "${DEVICELOGDIR}" ]; then
            local XCDLSIZE=$(du -hs "${DEVICELOGDIR}" | cut -f1)
            echo "   removing Xcode DeviceLogs (${XCDLSIZE})..."
            rm -rf "${DEVICELOGDIR}"
        fi

        # Xcode DeviceLogs
        local SIMULATORCACHEDIR="${DEVELOPERDIR}/CoreSimulator/Caches"
        if [ -d "${SIMULATORCACHEDIR}" ]; then
            local XCCACHESIZE=$(du -hs "${SIMULATORCACHEDIR}" | cut -f1)
            echo "   removing Xcode CoreSimulator Caches (${XCCACHESIZE})..."
            rm -rf "${SIMULATORCACHEDIR}"
        fi

        # iOS device support files
        local DEVICESUPPORTDIR="${DEVELOPERDIR}/Xcode/iOS DeviceSupport"
        if [ -d "${DEVICESUPPORTDIR}" ]; then
            # display commands to remove iOS device support files (but don't actually remove);
            #   e.g. this would display something like:
            #        - This command would recover 3812 megabytes:
            #            rm -rf "/Users/me/Library/Developer/Xcode/iOS DeviceSupport/iPhone12,8 17.6.1 (21G93)"
            local DEVICESUPPORTCOMMAND=$(
                du -hs "${DEVICESUPPORTDIR}"/* |
                    awk '{\
                    r=$0;\
                    gsub(/^[^[:space:]]+[[:space:]]+/,"",r);\
                    printf("- This command would recover an additional %s:\n    rm -rf \"%s\"\n",$1, r);\
                  }'
            )
            echo "${DEVICESUPPORTCOMMAND}"
            addHint "${DEVICESUPPORTCOMMAND}"
        fi

        echo "    removing unavailable simulator devices..."
        xcrun simctl delete unavailable

        echo "    removing all but the most recent iOS simulator runtime..."
        xcrun simctl runtime list | grep -E '^iOS' | sort -r -n -k 2 | awk 'NR>1{print $5}' | xargs -I{} xcrun simctl runtime delete {}

    fi # xcode
}
