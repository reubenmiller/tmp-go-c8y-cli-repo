FROM alpine:3.15

RUN apk add gcc abuild bash --no-cache
ENV RSA_PRIVATE_KEY=
VOLUME [ "/repo" ]

CMD "/repo/scripts/build-apk.sh"
