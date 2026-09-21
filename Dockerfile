FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG LIVE_USERNAME=macuser
ARG LIVE_USER_FULLNAME="Mac User"

RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY auto/ /build/auto/
COPY config/ /build/config/
COPY hooks/ /build/config/hooks/
COPY includes.chroot/ /build/config/includes.chroot/

RUN chmod +x /build/auto/build /build/config/hooks/*.sh 2>/dev/null || true

ENTRYPOINT ["/build/auto/build"]