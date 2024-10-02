xcodeArtifacts() {
    # ### XCode ###
    if [ -d ${HOME}/Library/Developer/Xcode ]; then
        echo "=== clearing Xcode folders ==="

        # Xcode DerivedData
        if [ -d ${HOME}/Library/Developer/Xcode/DerivedData ]; then
            local XCDDSIZE=$(du -hs ${HOME}/Library/Developer/Xcode/DerivedData | cut -f1)
            echo "   removing Xcode DerivedData(${XCDDSIZE})..."
            rm -rf ${HOME}/Library/Developer/Xcode/DerivedData
        fi

        # Xcode DeviceLogs
        if [ -d ${HOME}/Library/Developer/Xcode/DeviceLogs ]; then
            local XCDLSIZE=$(du -hs ${HOME}/Library/Developer/Xcode/DeviceLogs | cut -f1)
            echo "   removing Xcode DeviceLogs (${XCDLSIZE})..."
            rm -rf ${HOME}/Library/Developer/Xcode/DeviceLogs
        fi

        # Xcode DeviceLogs
        if [ -d ${HOME}/Library/Developer/CoreSimulator/Caches ]; then
            local XCCACHESIZE=$(du -hs ${HOME}/Library/Developer/CoreSimulator/Caches | cut -f1)
            echo "   removing Xcode Caches (${XCCACHESIZE})..."
            rm -rf ${HOME}/Library/Developer/CoreSimulator/Caches
        fi

        # iOS device support files
        if [ -d "${HOME}/Library/Developer/Xcode/iOS DeviceSupport" ]; then
            # display commands to remove iOS device support files (but don't actually remove);
            #   e.g. this would display something like:
            #        - This command would recover 3812 megabytes:
            #            rm -rf "/Users/me/Library/Developer/Xcode/iOS DeviceSupport/iPhone12,8 17.6.1 (21G93)"
            local DEVICESUPPORTCOMMAND=$(
                du -hs "${HOME}/Library/Developer/Xcode/iOS DeviceSupport/"* |
                    awk '{\
            r=$0;\
            gsub(/^[^[:space:]]+[[:space:]]+/,"",r);\
            printf("- This command would recover %s:\n    rm -rf \"%s\"\n",$1, r);\
          }'
            )
            echo "${DEVICESUPPORTCOMMAND}"
            HINTS_UPON_FINISH=$(printf "${HINTS_UPON_FINISH}\n${DEVICESUPPORTCOMMAND}")
        fi
    fi # xcode
}
