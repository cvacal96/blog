FROM python:3.11-slim

USER root

# Install required build tools and SQLite headers using APT
RUN apt-get update && \
    apt-get install -y gcc make automake autoconf libtool libsqlite3-dev curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/app-root/src

# Copy source code to the correct location
COPY . /opt/app-root/src

# Move S2I scripts
RUN mv .s2i/bin /tmp/scripts

# Fix permissions
RUN rm -rf .git* && \
    chown -R 1001 /opt/app-root/src && \
    chgrp -R 0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

# Set environment variables
ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1 \
    PATH=$PATH:/root/.local/bin

# Fix legacy path for pre_build compatibility
RUN ln -s /opt/app-root/src /tmp/src && /tmp/scripts/assemble


# Assemble the app (run as root to avoid permission issues during pip install)
RUN /tmp/scripts/assemble

# Switch to default non-root user
USER 1001

# Run the app
CMD [ "/tmp/scripts/run" ]
