FROM alpine:latest

ARG VPXTOOL_VERSION=0.19.1

RUN apk add --no-cache bash curl tar imagemagick libwebp-dev libjpeg openexr openexr-dev git gcc build-base libpng-dev libzip-dev zstd-dev zlib-dev bzip2-dev libxml2-dev libx11-dev libwmf-dev tiff-dev librsvg-dev libraw-dev openjpeg-dev libjxl-dev libltdl-static libtool libheif-dev ghostscript-dev fftw-dev cairo-dev

RUN git clone https://github.com/ImageMagick/ImageMagick/
RUN cd ImageMagick && git checkout tags/7.1.1-47 && ./configure --with-modules --with-rsvg=yes --with-wmf=yes --with-ltdl=yes --with-gslib=yes --with-fftw=yes && make && make install
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
