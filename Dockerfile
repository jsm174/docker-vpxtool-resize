FROM alpine:latest

ARG VPXTOOL_VERSION=0.19.1

RUN apk add --no-cache bash curl tar imagemagick libwebp-dev libjpeg

RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        TOOL_URL="https://github.com/francisdb/vpxtool/releases/download/v${VPXTOOL_VERSION}/vpxtool-Linux-x86_64-musl-v${VPXTOOL_VERSION}.tar.gz"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        TOOL_URL="https://github.com/francisdb/vpxtool/releases/download/v${VPXTOOL_VERSION}/vpxtool-Linux-aarch64-musl-v${VPXTOOL_VERSION}.tar.gz"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -L "$TOOL_URL" -o /tmp/vpxtool.tar.gz && \
    mkdir -p /opt/vpxtool && \
    tar -xzf /tmp/vpxtool.tar.gz -C /opt/vpxtool && \
    chmod +x /opt/vpxtool/vpxtool && \
    rm /tmp/vpxtool.tar.gz 

ENV PATH="/opt/vpxtool:$PATH"

WORKDIR /workspace

COPY resize.sh /usr/local/bin/resize
RUN chmod +x /usr/local/bin/resize

ENTRYPOINT ["/usr/local/bin/resize"]
