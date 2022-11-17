#!/bin/bash
#
# https://www.linkedin.com/pulse/creating-alpine-linux-package-repository-afam-agbodike
# https://www.erianna.com/creating-a-alpine-linux-repository/
#

set -euo pipefail

if [[ -z "$RSA_PRIVATE_KEY" ]]; then
    echo "Missing env variable: RSA_PRIVATE_KEY"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_BASE=$( cd "$SCRIPT_DIR/.." && pwd )

docker build -t "apk" -f "$SCRIPT_DIR/alpine.dockerfile" "$SCRIPT_DIR"
docker run \
    --rm \
    -v "$REPO_BASE:/repo" \
    --env "RSA_PRIVATE_KEY=$RSA_PRIVATE_KEY" \
    apk /repo/scripts/build-apk.sh
