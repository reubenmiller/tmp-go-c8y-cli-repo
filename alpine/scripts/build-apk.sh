#!/bin/bash
#
# https://www.linkedin.com/pulse/creating-alpine-linux-package-repository-afam-agbodike
# https://www.erianna.com/creating-a-alpine-linux-repository/
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_BASE=$( cd "$SCRIPT_DIR/.." && pwd )
INCOMING="${1:-$SCRIPT_DIR/../incoming}"

RSA_KEY_FILE=/root/reuben.d.miller@gmail.com-61e3680b.rsa
echo "$RSA_PRIVATE_KEY" | tr "," "\n" > "$RSA_KEY_FILE"

index_packages () {
    filter=$1
    arch=$2
    CURRENT_BASE="$REPO_BASE/stable/main/$arch"

    mkdir -p "$CURRENT_BASE"

    echo "Removing any older versions"
    rm -f "$CURRENT_BASE/"*.apk

    cp "$INCOMING"/*"$filter"*.apk "$CURRENT_BASE/"

    # Rename apk file to match: go-c8y-cli_2.4.5_linux_386.apk =>  go-c8y-cli-2.4.5.apk
    # As the apk index expects it in this format
    for apk_file in "$CURRENT_BASE/"*.apk
    do
        new_name=$( basename "$apk_file" | cut -d"_" -f1-2 | tr "_" "-" )
        mv "$apk_file" "$CURRENT_BASE/${new_name}.apk"
    done

    apk index -o "$CURRENT_BASE/APKINDEX.unsigned.tar.gz" "$CURRENT_BASE"/*.apk
    cp -f "$CURRENT_BASE/APKINDEX.unsigned.tar.gz" "$CURRENT_BASE/APKINDEX.tar.gz"

    abuild-sign -k "$RSA_KEY_FILE" "$CURRENT_BASE/APKINDEX.tar.gz"
}

index_packages "amd64" "x86_64"
index_packages "armv7" "armv7"
index_packages "386" "x86"
