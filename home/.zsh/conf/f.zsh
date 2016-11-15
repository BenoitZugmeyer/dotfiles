function f () {
    filter=$1
    shift
    find -iname "*$filter*" "$@"
}
