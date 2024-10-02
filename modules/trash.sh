trash() {
    # remove everything from Trash - this sometimes prompts for confirmation
    local TRASHSIZE=$(du -hs "${HOME}/.Trash" | cut -f1)
    echo "=== emptying trash (${TRASHSIZE}) ==="
    rm -rf "${HOME}/.Trash/*"
}
