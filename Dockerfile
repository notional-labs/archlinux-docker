ARG ARCH=amd64
FROM ghcr.io/notional-labs/archlinux-$ARCH

ARG ARCHDIR="rootfs/amd64"

WORKDIR /archlinux

RUN mkdir -p /archlinux/rootfs
# Pacstrap uses the existing mirrorlist, need to update early

RUN echo 'Server = https://ftp.gwdg.de/pub/linux/manjaro/$repo/os/$arch' > /etc/pacman.d/mirrorlist

RUN echo 'Creating install root at %s' "$newroot" && \
mkdir -m 0755 -p /archlinux/rootfs/var/{cache/pacman/pkg,lib/pacman,log} /archlinux/rootfs/{dev,run,etc} && \
mkdir -m 1777 -p /archlinux/rootfs/tmp && \
mkdir -m 0555 -p /archlinux/rootfs/{sys,proc} && \
mknod /archlinux/rootfs/dev/null c 1 3 && \
pacman -r /archlinux/rootfs -Sy --noconfirm bash sed gzip pacman && \
pacman -r /archlinux/rootfs -Syyu --noconfirm archlinux-keyring && \
rm "/archlinux/rootfs/dev/null"

RUN rm rootfs/var/lib/pacman/sync/*

FROM scratch
ARG ARCH=amd64

COPY --from=0 /archlinux/rootfs/ /
COPY rootfs/common/ /
COPY rootfs/$ARCH/ /

ENV LANG=en_US.UTF-8

RUN locale-gen && \
    pacman-key --init 
    
RUN pacman-key --populate archlinux manjaro

CMD ["/usr/bin/bash"]
