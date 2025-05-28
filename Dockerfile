# ---------------------------
# Stage 1: Build Tippecanoe
# ---------------------------
FROM ubuntu:22.04 AS tippecanoe-builder

# Install build tools
RUN apt-get update && \
    apt-get -y install git make gcc g++ libsqlite3-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone tippecanoe at the specified tag
WORKDIR /tmp
RUN git clone --branch 2.78.0 https://github.com/felt/tippecanoe.git tippecanoe-src

# Build tippecanoe
WORKDIR /tmp/tippecanoe-src
RUN make



# ---------------------------
# Stage 2: Final Image
# ---------------------------
FROM python:3.12-slim

ARG VERSION=1.18.0

LABEL maintainer="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.created="$(date +%Y-%m-%d %H:%M)" \
      org.opencontainers.image.authors="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.url="https://hub.docker.com/r/alcapone1933/script-server" \
      org.opencontainers.image.version="v${VERSION}" \
      org.opencontainers.image.ref.name="alcapone1933/script-server" \
      org.opencontainers.image.title="script-server" \
      org.opencontainers.image.description="Web UI for your scripts with execution management"

ENV TZ=Asia/Jerusalem
ENV PYTHONUNBUFFERED=1

# Install dependencies, timezone, script-server, and Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        tzdata \
        docker.io \
        libsqlite3-0 && \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    mkdir -p /app/conf && \
    curl -L https://github.com/bugy/script-server/releases/download/${VERSION}/script-server.zip -o /tmp/script-server.zip && \
    unzip /tmp/script-server.zip -d /app && \
    rm -f /tmp/script-server.zip && \
    pip install --no-cache-dir -r /app/requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy tippecanoe binaries
COPY --from=tippecanoe-builder /tmp/tippecanoe-src/tippecanoe* /usr/local/bin/
COPY --from=tippecanoe-builder /tmp/tippecanoe-src/tile-join /usr/local/bin/

# Copy app config
COPY app/ /app/

# Set working directory
WORKDIR /app

# Expose Script Server port
EXPOSE 5000

# Launch Script Server
CMD ["python", "launcher.py"]
