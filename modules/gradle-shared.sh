gradleShared() {
    # Clear gradle caches
    if [ -d ${HOME}/.gradle/caches ]; then
        local GCSIZE=$(du -hs ${HOME}/.gradle/caches | cut -f1)
        echo "=== clearing shared gradle caches...($GCSIZE)"
        rm -rf ${HOME}/.gradle/caches
    fi
}
