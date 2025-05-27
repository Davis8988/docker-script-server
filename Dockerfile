# Use UBI 8 with Python 3.9
FROM registry.access.redhat.com/ubi8/python-39

# Argument for Script Server version
ARG VERSION=1.18.0

# Labels for metadata
LABEL maintainer="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.created="$(date +%Y-%m-%d %H:%M)" \
      org.opencontainers.image.authors="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.url="https://hub.docker.com/r/alcapone1933/script-server" \
      org.opencontainers.image.version="v${VERSION}" \
      org.opencontainers.image.ref.name="alcapone1933/script-server" \
      org.opencontainers.image.title="script-server" \
      org.opencontainers.image.description="Web UI for your scripts with execution management"

# Set timezone to Israel
ENV TZ=Asia/Jerusalem

# Install required packages
RUN microdnf install -y \
        curl \
        unzip \
        tzdata \
        docker \
    && microdnf clean all \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && mkdir -p /app/conf \
    && curl -L https://github.com/bugy/script-server/releases/download/$VERSION/script-server.zip -o /tmp/script-server.zip

# Copy custom configuration
COPY app/ /app/

# Set working directory
WORKDIR /app

# Unzip script-server and install Python requirements
RUN unzip /tmp/script-server.zip -d /app && \
    rm -f /tmp/script-server.zip && \
    pip3 install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5000

# Run the script-server
CMD ["python3", "launcher.py"]

