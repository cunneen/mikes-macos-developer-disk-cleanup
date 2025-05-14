vscodeextensions(){
    local CACHEFOLDER="${HOME}/.vscode/extensions"
    if [ -d "${CACHEFOLDER}" ]; then
        
        local SIZEBEFORE=$(du -hs "${CACHEFOLDER}" | cut -f1)
        echo "=== removing $SIZEBEFORE of VSCode extensions ==="
        rm -rf "${CACHEFOLDER}"
    fi
}
