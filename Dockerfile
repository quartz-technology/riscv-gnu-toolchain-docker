FROM ubuntu:22.04 AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    python3-pip \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    ninja-build \
    git \
    cmake \
    libglib2.0-dev \
    libslirp-dev

RUN git clone https://github.com/riscv/riscv-gnu-toolchain .

# Newlib installation.
RUN ./configure --enable-multilib
RUN make

# Linux installation.
RUN ./configure --enable-multilib
RUN make linux

FROM ubuntu:22.04 AS runtime

WORKDIR /

COPY --from=builder /usr/local /usr/local

ENTRYPOINT [ "/bin/bash" ]