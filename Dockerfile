FROM alpine:latest
MAINTAINER MaxDuke <maxduke@gmail.com>

ENV ARIANG_VERSION 1.1.4

COPY root/ /

RUN set -xe \
	&& apk update \
	&& apk add --no-cache aria2 darkhttpd \
	&& mkdir -p aria2/conf aria2/downloads aria-ng \
	&& wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/$ARIANG_VERSION/AriaNg-$ARIANG_VERSION.zip \
	&& unzip AriaNg-$ARIANG_VERSION.zip -d aria-ng \
	&& rm -rf AriaNg-$ARIANG_VERSION.zip /var/cache/apk/* \
	&& chmod +x /init.sh

VOLUME ["/aria2/conf", "/aria2/downloads"]
EXPOSE 6800 80 8080

ENTRYPOINT ["/init.sh"]
