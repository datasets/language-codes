#!/bin/bash
# language-codes.sh - format standard language codes
# usage: language-codes.sh [-fk] [source file | url] [destination]

DEST="data"
FILE="http://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt"

# Error handling
set -e
set -u

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
set +u
if [[ -n ${1} ]]; then
    FILE="${1}"
fi
if [[ -n ${2} ]]; then
    DEST="${2}"
fi
set -u

# Internal vars
SELF="$0"
SELF_NAME=$(basename "${SELF}")
SRC="${DEST}/src"
COPY="source.txt"
LOG="log.txt"

# Protect preexisting paths
if [[ ${FORCE} != true ]] && [[ -e ${DEST} ]]; then
    echo "${SELF_NAME}: destination directory already exists: ${DEST}" >&2
    exit 1
fi
if [[ ${FORCE} != true ]] && [[ -e ${SRC} ]]; then
    echo "${SELF_NAME}: temporary source directory already exists: ${SRC}" >&2
    exit 1
fi

# Create paths
if ! mkdir -p ${DEST} 2>/dev/null; then
    echo "${SELF_NAME}: unable to create destination directory: ${DEST}" >&2
    exit 1
fi
if ! mkdir -p ${SRC} 2>/dev/null; then
    echo "${SELF_NAME}: unable to create temporary source directory: ${SRC}" >&2
    exit 1
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
    exit 1
fi
if ! touch "${DEST}/language-codes-full.csv" \
           "${DEST}/language-codes.csv"; then
    echo "${SELF_NAME}: unable to write output" >&2
    exit 1
fi

# Format all records and fields
echo '"alpha3-b","alpha3-t","alpha2","English","French"' > "${DEST}/language-codes-full.csv"
cat "${SRC}/${COPY}" | awk -F'|' -v QQ='"' -v OFS='","' '$1=$1 { print QQ $0 QQ }' >> "${DEST}/language-codes-full.csv"

# Only alpha2
echo '"alpha2","English"' > "${DEST}/language-codes.csv"
cat "${SRC}/${COPY}" | awk -F'|' '$3 { printf "\"%s\",\"%s\"\n", $3, $4 }' | sort >> "${DEST}/language-codes.csv"

if [[ ! ${KEEP} == true ]]; then
    # Clean up
    rm -rf "${SRC}"
else
    # Log source location
    echo "${COPY} created from ${FILE}" > "${SRC}/${LOG}"
fi

exit 0
