FROM ubuntu:jammy as build

LABEL description="Build vsomeip"
 
RUN apt-get update && apt-get install -y \
    binutils cmake curl gcc g++ git libboost-all-dev libtool make tar


ENV VSOMEIP_VERSION 3.5.1
ENV VSOMEIP_SHA256 TBD

RUN set -eux; \
# download

    curl -o vsomeip.tar.gz -fsSL "https://github.com/COVESA/vsomeip/archive/refs/tags/${VSOMEIP_VERSION}.tar.gz"; \
    tar -xf vsomeip.tar.gz -C /tmp/; \
# cleanup download
    rm vsomeip.tar.gz;

# build
RUN set -eux; \
    mv /tmp/vsomeip-${VSOMEIP_VERSION} /vsomeip; \
    cd /vsomeip; \
    mkdir build && cd build; \
    cmake ..; \
    make; \
    make install;

# build examples/hello_world
RUN set -eux; \
    cd /vsomeip/examples/hello_world; \
    mkdir build && cd build; \
    cmake ..; \
    make ;

RUN set -eux; \
    cd /vsomeip/build; \
    make examples;

RUN apt-get install -y iputils-ping iperf3

COPY . /work/config

