FROM kasmweb/core-ubuntu-noble:1.18.0

ARG TZ=America/Recife

LABEL br.com.uptech.app="@uptech/Cisco-PacketTracer"
LABEL maintainer="UPTECH <contato@uptech.com.br>"

ENV VNCOPTIONS="${VNCOPTIONS} -DisableBasicAuth"

USER root

RUN --mount=type=cache,id=cisco-pt,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=cisco-pt,target=/var/lib/apt,sharing=locked \
    set -eux; \
	\
    apt update; \
    apt install -y --no-install-recommends --no-install-suggests \
        tzdata \
        sudo \
        libqt5quick5 \
        debconf-utils \
    ; \
    \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime; \
    echo "$TZ" > /etc/timezone; \
    \
    echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY ./assets/*.deb /tmp/CiscoPacketTracer_Ubuntu_64bit.deb

RUN --mount=type=cache,id=cisco-pt,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=cisco-pt,target=/var/lib/apt,sharing=locked \
    set -eux; \
	\
    apt --no-install-suggests -fy install /tmp/CiscoPacketTracer_Ubuntu_64bit.deb; \
    rm -f /tmp/*

RUN set -eux; \
    \
    ln -sf /opt/pt/packettracer.AppImage /usr/local/bin/packettracer; \
    \
    /opt/pt/packettracer.AppImage --appimage-extract usr/share/icons/hicolor/48x48/apps/app.png; \
    install -D -m 0644 squashfs-root/usr/share/icons/hicolor/48x48/apps/app.png /usr/share/icons/hicolor/48x48/apps/cisco-packettracer.png; \
    rm -rf squashfs-root; \
    printf '%s\n' \
        '[Desktop Entry]' \
        'Version=1.0' \
        'Type=Application' \
        'Name=Cisco Packet Tracer' \
        'Comment=Cisco Packet Tracer' \
        'Exec=/usr/local/bin/packettracer %f' \
        'Icon=cisco-packettracer' \
        'Terminal=false' \
        'StartupNotify=true' \
        'Categories=Education;Network;' \
        'MimeType=application/x-pkt;application/x-pka;application/x-pkz;application/x-pks;application/x-pksz;' \
        > /usr/share/applications/cisco-packettracer.desktop; \
    chmod 755 /usr/share/applications/cisco-packettracer.desktop; \
    \
    install -d -o 1000 -g 0 /home/kasm-default-profile/Desktop /home/kasm-user/Desktop; \
    install -m 0755 -o 1000 -g 0 /usr/share/applications/cisco-packettracer.desktop "/home/kasm-default-profile/Desktop/Cisco Packet Tracer.desktop"; \
    install -m 0755 -o 1000 -g 0 /usr/share/applications/cisco-packettracer.desktop "/home/kasm-user/Desktop/Cisco Packet Tracer.desktop"

USER 1000
