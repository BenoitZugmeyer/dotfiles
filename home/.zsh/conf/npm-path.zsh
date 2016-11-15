ORIGINAL_PATH="$PATH"
function npm-path () {
    local npm_path=$(npm bin)
    echo "Adding $npm_path to the path"
    export PATH="$npm_path:$ORIGINAL_PATH"
}
