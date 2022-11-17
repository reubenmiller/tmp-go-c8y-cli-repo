
# About

This repository is responsible for hosting the latest [go-c8y-cli](https://goc8ycli.netlify.app/) packages as linux repository (apk/deb/rpm) via github pages.

# Build

The build script will download a release from the [go-c8y-cli repo](https://github.com/reubenmiller/go-c8y-cli) and add it to the repository so it can be installed via the supported linux package managers.

|Linux Distribution|Package Manager|File type|
|------------------|---------------|---------|
|Ubuntu/Debian|apt|.deb|
|alpine|apk|.apk|
|RHEL/CentOS/Fedora|yum/dnf|.rpm|

## Publish latest version

```sh
./build.sh
```

## Publish specific version

```sh
./build.sh --tag v2.4.0
```

## Troubleshooting

### Error when pulling latest code into your checkout repo

If you have a merge conflict due to conflicts with untracked files in the repo, then run the following git command to remove any untracked files in your checked out folder.

```sh
git clean -f
```
