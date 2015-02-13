#!/bin/bash
# language-codes.sh - format standard language codes
# usage: language-codes.sh [-fk] [source file | url] [destination]

language-codes() {

    OPTIND=1
    DEST="data"
    FILE="http://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt"

    # Arguments
    FORCE=false
    KEEP=false
    while getopts ":fk" OPT; do
        case "${OPT}" in
        f)
            # Force overwrite existing paths
            FORCE=true
            ;;
        k)
            # Keep temporary source copy and log
            KEEP=true
            ;;
        esac
    done
    shift $(($OPTIND - 1))
    if [[ -n ${1} ]]; then
        FILE="${1}"
    fi
    if [[ -n ${2} ]]; then
        DEST="${2}"
    fi

    # Internal vars
    SELF="${BASH_SOURCE[0]}"
    SELF_NAME=$(basename "${SELF}")
    SRC="${DEST}/src"
    COPY="source.txt"
    LOG="log.txt"

    # Protect preexisting paths
    if [[ ${FORCE} != true ]] && [[ -e ${DEST} ]]; then
        echo "${SELF_NAME}: destination directory already exists: ${DEST}" >&2
        return 1
    fi
    if [[ ${FORCE} != true ]] && [[ -e ${SRC} ]]; then
        echo "${SELF_NAME}: temporary source directory already exists: ${SRC}" >&2
        return 1
    fi

    # Create paths
    if ! mkdir -p ${DEST} 2>/dev/null; then
        echo "${SELF_NAME}: unable to create destination directory: ${DEST}" >&2
        return 1
    fi
    if ! mkdir -p ${SRC} 2>/dev/null; then
        echo "${SELF_NAME}: unable to create temporary source directory: ${SRC}" >&2
        return 1
    fi

    # Get source
    SUCCESS=false
    PROT=$(awk -F':\/\/' '$2 { print $1 }' <<< "${FILE}")
    case ${PROT} in
        http|https)
            if curl -s "${FILE}" > "${SRC}/${COPY}" 2>/dev/null; then
                SUCCESS=true
            fi
            ;;
        "")
            if [[ -f ${FILE} ]] && [[ -r ${FILE} ]] && cp "${FILE}" "${SRC}/${COPY}" 2>/dev/null; then
                SUCCESS=true
            fi
    esac

    # Sanity checks
    if [[ ${SUCCESS} != true ]]; then
        echo "${SELF_NAME}: unable to fetch source: ${FILE}" >&2
        return 1
    fi
    if ! touch "${DEST}/language-codes-full.csv" \
               "${DEST}/language-codes.csv" \
               "${DEST}/language-codes-3b2.csv"; then
        echo "${SELF_NAME}: unable to write output" >&2
        return 1
    fi

    # Format all records and fields
    echo '"alpha3-b","alpha3-t","alpha2","English","French"' > "${DEST}/language-codes-full.csv"
    cat "${SRC}/${COPY}" | awk -F'|' -v QQ='"' -v OFS='","' 'NR==1 { sub(/^\xef\xbb\xbf/, "") } $1=$1 { print QQ $0 QQ }' >> "${DEST}/language-codes-full.csv"

    # Only alpha2
    echo '"alpha2","English"' > "${DEST}/language-codes.csv"
    cat "${SRC}/${COPY}" | awk -F'|' 'NR==1 { sub(/^\xef\xbb\xbf/, "") } $3 { printf "\"%s\",\"%s\"\n", $3, $4 }' | sort >> "${DEST}/language-codes.csv"

    # Only alpha3-b with corresponding alpha2
    echo '"alpha3-b","alpha2","English"' > "${DEST}/language-codes-3b2.csv"
    cat "${SRC}/${COPY}" | awk -F'|' 'NR==1 { sub(/^\xef\xbb\xbf/, "") } $3 { printf "\"%s\",\"%s\",\"%s\"\n", $1, $3, $4 }' | sort >> "${DEST}/language-codes-3b2.csv"

    if [[ ${KEEP} == true ]]; then
        # Log source location
        echo "${COPY} created from ${FILE}" > "${SRC}/${LOG}"
    else
        # Clean up
        rm -rf "${SRC}"
    fi

    return 0

}

language-codes "$@"
