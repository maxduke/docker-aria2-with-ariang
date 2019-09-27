FROM alpine:latest
MAINTAINER MaxDuke <maxduke@gmail.com>

COPY root/ /

RUN set -xe \
	&& apk update \
	&& apk add --no-cache aria2 darkhttpd \
	&& mkdir -p aria2/conf aria2/downloads aria-ng \
	&& wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/1.1.3/AriaNg-1.1.3.zip \
	&& unzip AriaNg-1.1.3.zip -d aria-ng \
	&& rm -rf AriaNg-1.1.3.zip \
	&& chmod +x /init.sh

WORKDIR /
VOLUME ["/aria2/conf", "/aria2/downloads"]
EXPOSE 6800 80 8080

ENTRYPOINT ["/init.sh"]
