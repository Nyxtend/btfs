FROM ubuntu:latest

# Rough instructions derived from
# https://docs.filecoin.io/get-started/lotus/installation/#linux

# Install dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -qqy && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    build-essential \
    ca-certificates \
    curl \
    gpg \
    pkg-config \
    wget

# Setup working environment
RUN mkdir -p /work
WORKDIR /work

# Get latest install script
RUN wget https://raw.githubusercontent.com/TRON-US/btfs-binary-releases/master/install.sh && \
  chmod +x install.sh && \
  ./install.sh -o linux -a amd64

# Add BTFS to path
ENV PATH="${PATH}:/root/btfs/bin"

# Add startup script
WORKDIR /work
ADD docker-init.sh .
RUN chmod +x docker-init.sh

# Expose the btfs folders as volumes, these should be persisted
VOLUME [ "/root/.btfs" ]

# Expose the local API port (don't port forward this!)
EXPOSE 5001

# Start BTFS
CMD ["/work/docker-init.sh"]
