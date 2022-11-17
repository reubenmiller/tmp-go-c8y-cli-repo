#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd "$SCRIPT_DIR" || exit 1

TARGETS=()

FORCE=
COMMIT=
VERSION=
REPO=reubenmiller/go-c8y-cli

while [[ $# -gt 0 ]]; do
  case $1 in
    -R|--repo)
      REPO="$2"
      shift
      shift
      ;;
    --tag|--version)
      VERSION="$2"
      shift
      shift
      ;;
    --force)
      FORCE=YES
      shift
      ;;
    --commit)
      COMMIT=YES
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      TARGETS+=("$1")
      shift
      ;;
  esac
done

set -- "${TARGETS[@]}"

if [ "${#TARGETS[@]}" -lt 1 ]; then
    echo "Requires at least 1 build target, eg. apk|deb|rpm"
    exit 1
fi

LAST_PUBLISHED_SCRIPT="$SCRIPT_DIR/version"
LAST_PUBLISHED_VERSION=
if [ -f "$LAST_PUBLISHED_SCRIPT" ]; then
    LAST_PUBLISHED_VERSION=$( head -n1 "$LAST_PUBLISHED_SCRIPT" )
fi

if [ -z "$VERSION" ]; then
    echo "Checking latest release from $REPO"
    VERSION=$( gh release view -R "$REPO" --json tagName --jq ".tagName" )
    echo "Latest release is: $VERSION"
fi


run_script () {
    local package_type="$1"
    local script="$2"
    local ignore_pattern="${3:-}"
    local incoming_dir
    incoming_dir="$( dirname "$script" )/../incoming"

    if [[ " ${TARGETS[*]} " =~ \ $package_type\  ]]; then
        mkdir -p "$incoming_dir"
        echo "Downloading *.$package_type artifacts from $REPO to $incoming_dir"
        find "$incoming_dir" -name "*.$package_type" -delete
        gh release download "$VERSION" -R "$REPO" --pattern "*.$package_type" --dir "$incoming_dir"

        if [ -n "$ignore_pattern" ]; then
            echo "Deleting artifacts: pattern=$ignore_pattern"
            find "$incoming_dir" -name "$ignore_pattern" -delete
        fi

        echo "Building $package_type"
        "$script" "$incoming_dir"
    fi
}


version_lte() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1 )" ]
}


should_update () {
    if [[ "$FORCE" =~ [Yy][Ee][Ss]|1|true ]]; then
        echo "Forcing publishing of package due to --force option"
        return 0
    fi

    if version_lte "$VERSION" "$LAST_PUBLISHED_VERSION"; then
        return 1
    fi

    echo "Newer release detected. last_published=$LAST_PUBLISHED_VERSION, version=$VERSION"
    return 0
}


commit_changes () {
    echo "$VERSION" > "$LAST_PUBLISHED_SCRIPT" 

    if ! git diff-index --quiet HEAD --; then

        if [[ "$COMMIT" =~ [Yy][Ee][Ss]|1|true ]]; then

            if declare -p CI >&/dev/null ; then
                echo "Setting CI/CD git config"
                git config --global user.email "ci_cd@github.com"
                git config --global user.name "ci_cd"
            else
                echo "Fixing folder ownership (when not in CI mode)"
                sudo chown -R "$(whoami):$(whoami)" ./
            fi

            echo "Commit changes. version=$VERSION"
            git add --all
            git commit -m "Publishing new release: $VERSION"
            git push
        else
            echo "DRY: Committing new release: $VERSION"
        fi
    fi
}

fix_file_ownership () {
    # Fix file ownership due to running build scripts under docker root
    # Change the ownership of all files in the repo to the current user
    if ! declare -p CI >&/dev/null ; then
        echo "Fixing folder ownership (when not in CI mode)"
        sudo chown -R "$(whoami):$(whoami)" ./
    fi
}


if ! should_update; then
    echo "Skipping version as it has already been published"
    exit 0
fi

run_script "apk" "./alpine/scripts/build.sh"
run_script "deb" "./debian/scripts/build.sh" "*armv7*.deb"
run_script "rpm" "./rpm/scripts/build.sh"

fix_file_ownership

commit_changes

popd > /dev/null
