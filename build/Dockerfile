FROM alpine:3.10 AS no-plugin
MAINTAINER toph <toph@toph.fr>
RUN apk add --no-cache ca-certificates
RUN wget -q -O /usr/local/bin/akamai https://github.com/akamai/cli/releases/download/1.1.4/akamai-1.1.4-linuxamd64 \
    && chmod a+x /usr/local/bin/akamai
RUN mkdir -p /root/.akamai-cli/cache
COPY config /root/.akamai-cli/config
ENTRYPOINT ["/usr/local/bin/akamai"]


FROM no-plugin AS api-gateway.package
RUN akamai install --force api-gateway
FROM api-gateway.package AS api-gateway
ENTRYPOINT ["/usr/local/bin/akamai", "api-gateway"]
FROM api-gateway.package AS api-keys
ENTRYPOINT ["/usr/local/bin/akamai", "api-keys"]
FROM api-gateway.package AS api-security
ENTRYPOINT ["/usr/local/bin/akamai", "api-security"]

FROM no-plugin AS dns
RUN akamai install --force dns
ENTRYPOINT ["/usr/local/bin/akamai", "dns"]

FROM no-plugin AS purge
RUN akamai install --force purge
ENTRYPOINT ["/usr/local/bin/akamai", "purge"]


# Node
FROM no-plugin AS node_
RUN apk add --no-cache nodejs
ENV BUILD_DEPS npm

FROM node_ AS appsec
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force appsec \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "appsec"]

FROM node_ AS auth
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force auth \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "auth"]

FROM node_ AS edgeworkers
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force edgeworkers \
    && cd /root/.akamai-cli/src/cli-edgeworkers && npm run build \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "edgeworkers"]

FROM node_ AS netstorage
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force netstorage \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "netstorage"]

FROM node_ AS property
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force property\
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "property"]

FROM node_ AS property-manager.package
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force property-manager \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
FROM property-manager.package AS snippets
ENTRYPOINT ["/usr/local/bin/akamai", "snippets"]
FROM property-manager.package AS pipeline
ENTRYPOINT ["/usr/local/bin/akamai", "pipeline"]


# Python 3
FROM no-plugin AS py3_
RUN apk add --no-cache \
        libffi \
        openssl \
        python3
ENV BUILD_DEPS \
        build-base \
        libffi-dev \
        openssl-dev \
        python3-dev

FROM py3_ AS adaptive-acceleration
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force adaptive-acceleration \
    && rm -rf /root/.cache \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "adaptive-acceleration"]

FROM py3_ AS cps
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force cps \
    && rm -rf /root/.cache \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "cps"]

FROM py3_ AS firewall.package
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force firewall \
    && rm -rf /root/.cache \
    && apk del .build-deps
FROM firewall.package AS firewall
ENTRYPOINT ["/usr/local/bin/akamai", "firewall"]
FROM firewall.package AS site-shield
ENTRYPOINT ["/usr/local/bin/akamai", "site-shield"]

FROM py3_ AS image-manager
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force image-manager \
    && rm -rf /root/.cache \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "image-manager"]

FROM py3_ AS mpulse
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force mpulse \
    && rm -rf /root/.cache \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "mpulse"]

FROM py3_ AS visitor-prioritization
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force visitor-prioritization \
    && rm -rf /root/.cache \
    && apk del .build-deps
ENTRYPOINT ["/usr/local/bin/akamai", "visitor-prioritization"]


FROM py3_ AS all
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && akamai install --force \
        adaptive-acceleration \
        cps \ 
        firewall \
        image-manager \
        mpulse \
        visitor-prioritization \
    && rm -rf /root/.cache \
    && apk del .build-deps
RUN akamai install --force api-gateway
RUN akamai install --force dns
RUN akamai install --force purge
RUN apk add --no-cache nodejs
RUN apk add --no-cache --virtual .build-deps npm \
    && akamai install --force \
        appsec \
        auth \
        edgeworkers \
        netstorage \
        property \
    && cd /root/.akamai-cli/src/cli-edgeworkers && npm run build \
    && rm -rf /root/.npm /root/.config \
    && apk del .build-deps
