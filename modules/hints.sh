addHint(){
    local HINTLENGTH=${#HINTS_UPON_FINISH}
    if [ ${HINTLENGTH} -gt 0 ]; then
        # add a newline if there was a previous hint
        HINTS_UPON_FINISH=$(printf "%s\n%s", "${HINTS_UPON_FINISH}", "${1}")
    else
        HINTS_UPON_FINISH="${1}"
    fi
}