FROM quay.io/centos/centos:stream9

RUN dnf install -y createrepo rpm-sign pinentry
ENV GPG_PRIVATE_KEY=
VOLUME [ "/repo" ]

CMD "/repo/scripts/build-rpm.sh"
