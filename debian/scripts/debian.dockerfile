FROM debian:11

RUN apt update \
    && apt install -y reprepro gnupg2
ENV GPG_PRIVATE_KEY=
VOLUME [ "/repo" ]

CMD "/repo/scripts/build-debian.sh"
