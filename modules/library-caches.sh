# remove everything in ~/Library/Caches
libraryCaches() {
    local THISMODULEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    local CACHEPATH=$(realpath $HOME/Library/Caches );
    echo "=== emptying ~/Library/Caches... ==="
    # # find files in use
    # lsof -w -b +c 32 -n | \
    #     awk -v CACHEPATH=$CACHEPATH \
    #         -f ${THISMODULEDIR}/library-caches-lsof-output.awk
    

    local LIBRARYCACHESIZE=$((du -hs "${HOME}/Library/Caches" 2>/dev/null | cut -f1 ) || echo "ERROR: COULD NOT RUN 'du'")
    echo "    Library Caches size: ${LIBRARYCACHESIZE}"

    # now for ~/.cache
    if [ -d ${HOME}/.cache ]; then
        CACHEPATH=$(realpath $HOME/.cache )
        echo "=== emptying ${CACHEPATH}... ==="
        # find files in use
        # lsof -w -b +c 32 -n | \
        #     awk -v CACHEPATH=$CACHEPATH \
        #         -f ${THISMODULEDIR}/library-caches-lsof-output.awk
        

        LIBRARYCACHESIZE=$((du -hs "${CACHEPATH}" 2>/dev/null | cut -f1 ) || echo "ERROR: COULD NOT RUN 'du'")
        echo "    ${CACHEPATH} size: ${LIBRARYCACHESIZE}"
    fi

    rm -rf "${HOME}/Library/Caches" || echo "=== ERROR! COULD NOT empty ~/Library/Caches. Continuing. ==="    
    rm -rf "${HOME}/.cache" || echo "=== ERROR! COULD NOT empty ~/.cache. Continuing. ==="    
}
