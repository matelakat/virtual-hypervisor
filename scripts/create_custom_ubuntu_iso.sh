#!/bin/bash

set -eu

function print_usage_and_quit
{
cat << USAGE >&2
usage: $(basename $0) ISOFILE TARGET_ISO PRESEEDFILE

Re-master an Ubuntu iso file for unattended operation.

Positional arguments:
 ISOFILE - Ubuntu iso file
 TARGET_ISO  - The target iso file to produce
 PRESEEDFILE - Preseed file to use
USAGE
exit 1
}

ORIGINAL_ISO="${1-$(print_usage_and_quit)}"
TARGET_ISO="${2-$(print_usage_and_quit)}"
PRESEEDFILE="${3-$(print_usage_and_quit)}"
PRESEEDFILE=$(readlink -f "$PRESEEDFILE")

TOP_DIR=$(cd $(dirname "$0") && cd .. && pwd)

function extract_iso
{
    [ -e "$1" ]
    [ -d "$2" ]

    TEMPTGT=$(mktemp -d)
    echo "Mounting $1 to $TEMPTGT"

    fuseiso "$1" "$TEMPTGT"

    echo "Copying $TEMPTGT to $2"
    tar -cf - -C "$TEMPTGT" ./ | tar -xf - -C "$2"
    chmod -R u+w "$2"

    fusermount -u "$TEMPTGT"
    rm -rf "$TEMPTGT"
}

function set_menu
{
    cp "$1" "$2/isolinux/txt.cfg"
}

function set_preseed
{
    cp "$1" "$2/autoinst.seed"
}

function set_timeout
{
    sed -ie 's/^\(timeout\) .*/\1 10/g' "$1/isolinux/isolinux.cfg"
}

function create_iso
{
    isocmd="mkisofs"
    command -v "$isocmd" >/dev/null 2>&1 || isocmd="genisoimage"
    $isocmd -r -V "Automated Ubuntu Install CD" \
    -cache-inodes \
    -J -l -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -no-emul-boot \
    -boot-load-size 4 -boot-info-table \
    -quiet \
    -o "$2" "$1"
}

ISOROOT="${ISOROOT-`mktemp -d`}"
extract_iso "$ORIGINAL_ISO" "$ISOROOT"
set_menu "$TOP_DIR/data/ubuntu_isolinux_txt.cfg" "$ISOROOT"
set_preseed "$PRESEEDFILE" "$ISOROOT"
set_timeout "$ISOROOT"
create_iso "$ISOROOT" "$TARGET_ISO"
rm -rf "$ISOROOT"
