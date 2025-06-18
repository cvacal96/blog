FROM python:3.11-slim

USER root

RUN apt-get update && \
    apt-get install -y gcc make automake autoconf libtool libsqlite3-dev curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app-root/src

COPY . /opt/app-root/src

# Move S2I scripts to a temp location
RUN mv /opt/app-root/src/.s2i/bin /tmp/scripts

# Fix permissions and clean .git files
RUN rm -rf /opt/app-root/src/.git* && \
    chown -R 1001 /opt/app-root/src && \
    chgrp -R 0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1 \
    PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore

# **Delete any existing .s2i dir in /opt/app-root/src before assemble**
RUN rm -rf /opt/app-root/src/.s2i && /tmp/scripts/assemble

USER 1001

CMD [ "/tmp/scripts/run" ]