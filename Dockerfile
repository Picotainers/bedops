FROM debian:bookworm AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential \
    zlib1g-dev \
    perl \
    python3 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone --depth 1 https://github.com/bedops/bedops.git
WORKDIR /tmp/bedops
RUN make -j"$(nproc)" && make install

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libstdc++6 \
    zlib1g \
    perl \
    python3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/bedops/bin/ /usr/local/bin/

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/bedops"]
CMD ["--help"]
