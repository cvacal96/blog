FROM python:3.11-slim

USER root

# Install required build tools and SQLite headers
RUN apt-get update && \
    apt-get install -y gcc make automake autoconf libtool libsqlite3-dev curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/app-root/src

# Copy the project source into the image
COPY . /opt/app-root/src

# Move S2I scripts to a temporary path
RUN mv /opt/app-root/src/.s2i/bin /tmp/scripts

# Clean .git files and fix permissions
RUN rm -rf /opt/app-root/src/.git* && \
    chown -R 1001 /opt/app-root/src && \
    chgrp -R 0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

# Create /tmp/src with a copy of the source for the assemble script
RUN mkdir -p /tmp/src && cp -a /opt/app-root/src/. /tmp/src/

# Set required environment variables
ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1 \
    PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore

# Run the assemble script (only once)
RUN /tmp/scripts/assemble

# Switch to default non-root user for runtime
USER 1001

# Run the application
CMD [ "/tmp/scripts/run" ]