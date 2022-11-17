
# Setup repository

## Alpine Linux

1. Add the repository

    ```sh
    wget -O /etc/apk/keys/reuben.d.miller\@gmail.com-61e3680b.rsa.pub https://reubenmiller.github.io/go-c8y-cli-repo/alpine/PUBLIC.KEY

    # Add the repo
    sh -c "echo 'https://reubenmiller.github.io/go-c8y-cli-repo/alpine/stable/main'" >> /etc/apk/repositories
    ```

2. Update the repo and install go-c8y-cli

    ```sh
    apk update
    apk add go-c8y-cli
    ```
