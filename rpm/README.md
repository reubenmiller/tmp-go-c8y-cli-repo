# Setting up the repository

## CentOS/RHEL/Fedora (dnf/yum)

1. Configure the repository 

    Create a new file using your editor of choice (vi, vim, nano etc.)

    ```sh
    sudo vi /etc/yum.repos.d/go-c8y-cli.repo
    ```

    Then add the following contents to it and save the file.

    ```text title="/etc/yum.repos.d/go-c8y-cli.repo"
    [go-c8y-cli]
    name=go-c8y-cli packages
    baseurl=https://reubenmiller.github.io/go-c8y-cli-repo/rpm/stable
    enabled=1
    gpgcheck=1
    gpgkey=https://reubenmiller.github.io/go-c8y-cli-repo/rpm/PUBLIC.KEY
    ```

2. Update the repo then install/update `go-c8y-cli`

    ```sh
    sudo dnf update
    sudo dnf install go-c8y-cli
    ```
