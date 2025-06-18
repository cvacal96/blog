FROM registry.access.redhat.com/ubi8/python-39

USER root

RUN yum install -y gcc make automake autoconf libtool sqlite-devel curl && \
    yum clean all

WORKDIR /opt/app-root/src

COPY . /opt/app-root/src

RUN mv /opt/app-root/src/.s2i/bin /tmp/scripts || true

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

RUN rm -rf /opt/app-root/src/.s2i && /usr/libexec/s2i/assemble

USER 1001

CMD [ "/tmp/scripts/run" ]