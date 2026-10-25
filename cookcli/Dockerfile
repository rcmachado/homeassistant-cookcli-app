ARG BUILD_FROM=ghcr.io/hassio-addons/ubuntu-base:stable

FROM $BUILD_FROM AS base

ENV LANG C.UTF-8
ARG BUILD_ARCH
ARG BUILD_VERSION

COPY rootfs /
COPY --from=ghcr.io/lemyst/cookcli:pr-773 /usr/local/bin/cook /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
