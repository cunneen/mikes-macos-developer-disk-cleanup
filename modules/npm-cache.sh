npmCache() {
    # npm cache
    command -v npm >/dev/null 2>&1 && {
        echo "=== removing npm cache ==="
        npm cache clean --force
    }
    #npm
}
