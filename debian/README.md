
# Setup repository

## Debian >=9 / Ubuntu >=16.04

1. Install package manager dependencies

    **Note**
    
    The following command requires you to already have `sudo` installed. If it is not then you will need to install it via apt.

    ```
    sudo apt-get update && apt-get install -y curl gnupg2 apt-transport-https
    ```

2. Add the repository gpg key

    ```bash
    curl https://reubenmiller.github.io/go-c8y-cli-repo/debian/PUBLIC.KEY | gpg --dearmor | sudo tee /usr/share/keyrings/go-c8y-cli-archive-keyring.gpg >/dev/null
    ```

    **Note**
    
    This step does not make use of `apt-key` as it has been deprecated. The gpg key is stored in an individual store only related to the go-c8y-cli repository, and it is linked via the apt.source settings using the "signed-by" property.

3. Configure the repository

    ```bash
    sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/go-c8y-cli-archive-keyring.gpg] http://reubenmiller.github.io/go-c8y-cli-repo/debian stable main' >> /etc/apt/sources.list"
    ```

4. Update the repo then install/update `go-c8y-cli`

    ```bash
    sudo apt-get update
    sudo apt-get install go-c8y-cli
    ```

## Debian <= 8 or Ubuntu <= 14.04

1. Install package manager dependencies

    **Note**
    
    The following command requires you to already have `sudo` installed. If it is not then you will need to install it via apt.

    ```
    sudo apt-get update && apt-get install -y gnupg2 apt-transport-https
    ```

2. Add the repository gpg key

    ```bash
    curl https://reubenmiller.github.io/go-c8y-cli-repo/debian/PUBLIC.KEY | sudo apt-key add -
    ```

3. Configure the repository

    ```bash
    sudo sh -c "echo 'deb https://reubenmiller.github.io/go-c8y-cli-repo/debian stable main' >> /etc/apt/sources.list"
    ```

4. Update the repo then install/update `go-c8y-cli`

    ```bash
    sudo apt-get update
    sudo apt-get install go-c8y-cli
    ```

# Maintainers

## Publish a package to the repository

To publish the latest version of go-c8y-cli to this repository it requires the following dependencies

* gh (github cli tool)
* jq
* reprorepo
* gnupg
* GPG private key used to sign the repository

1. Make sure you have the gpg signing key (This can only be done via a maintainer)

2. Run the build script. This will commit any changes to the repository if there is a newer go-c8y-cli version

    ```bash
    ./debian/scripts/build.sh
    ```

# References

This repository was made possible by the following posts:

* https://pmateusz.github.io/linux/2017/06/30/linux-secure-apt-repository.html
