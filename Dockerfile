FROM python:3.11-slim

USER root

# Install required build tools and SQLite headers using APT (Debian-based package manager)
RUN apt-get update && \
    apt-get install -y gcc make automake autoconf libtool libsqlite3-dev curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project source into the image
COPY . /tmp/src

# Move S2I scripts to a custom location
RUN mv /tmp/src/.s2i/bin /tmp/scripts

# Clean up .git files and fix permissions for OpenShift compatibility
RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

# Set required environment variables
ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1

# Assemble application using custom scripts
RUN /tmp/scripts/assemble

# Start the app
CMD [ "/tmp/scripts/run" ]
