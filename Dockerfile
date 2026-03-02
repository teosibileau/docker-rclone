FROM alpine:latest

# global environment settings
ENV RCLONE_PLATFORM_ARCH="amd64"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# install packages
RUN \
 apk update && \
 apk add --no-cache \
 ca-certificates

# install build packages
RUN apk add --no-cache --virtual=build-dependencies \
		wget \
		curl \
		unzip \
		xz

ENV OVERLAY_PLATFORM_ARCH="x86_64"
ENV OVERLAY_VERSION="v3.1.6.1"
ENV OVERLAY_DOWNLOAD_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_PLATFORM_ARCH}.tar.xz"
RUN curl -o \
	/tmp/s6-overlay.tar.xz -L \
	${OVERLAY_DOWNLOAD_URL}
RUN tar xf /tmp/s6-overlay.tar.xz -C /

RUN wget -q "https://downloads.rclone.org/rclone-current-linux-${RCLONE_PLATFORM_ARCH}.zip" \
		 -O "/tmp/rclone-current-linux-${RCLONE_PLATFORM_ARCH}.zip"
RUN cd /tmp/ && unzip -j "/tmp/rclone-current-linux-${RCLONE_PLATFORM_ARCH}.zip"
RUN mv /tmp/rclone /usr/bin
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	shadow && \
	apk del --purge \
	build-dependencies && \
	rm -rf \
	/tmp/* \
	/var/tmp/* \
	/var/cache/apk/*

# create abc user
RUN \
	groupmod -g 1000 users && \
	useradd -u 911 -U -d /config -s /bin/false abc && \
	usermod -G users abc && \
# create some files / folders
	mkdir -p /config /app /defaults /data && \
	touch /var/lock/rclone.lock

VOLUME ["/config"]

# ENTRYPOINT [ "/bin/sh" ]
CMD ["/usr/bin/rclone", "--version"]
