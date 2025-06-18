FROM registry.access.redhat.com/ubi8/python-39

USER root

RUN yum install -y \
        gcc make automake autoconf libtool \
        sqlite-devel curl \
    && yum clean all

# Copia los scripts S2I
COPY .s2i/bin /usr/libexec/s2i

# Crea el directorio de trabajo y ajusta permisos
RUN mkdir -p /opt/app-root/src && \
    chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

WORKDIR /opt/app-root/src

# Variables de entorno
ENV PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONUNBUFFERED=1

USER 1001

CMD ["/bin/bash"]
