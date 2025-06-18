FROM registry.access.redhat.com/ubi8/python-39

USER root

RUN yum install -y gcc make automake autoconf libtool sqlite-devel curl && yum clean all

# Copia solo los scripts s2i a la ruta estándar (ojo que debes tener la carpeta .s2i/bin con los scripts assemble y run)
COPY .s2i/bin /usr/libexec/s2i

# Establece el directorio de trabajo donde irá el código (inyectado por s2i)
WORKDIR /opt/app-root/src

# Ajustar permisos en el directorio (aunque el código aún no está)
RUN mkdir -p /opt/app-root/src && \
    chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

ENV PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONUNBUFFERED=1

USER 1001

# El run script será ejecutado por s2i o al arrancar el contenedor
CMD ["/usr/libexec/s2i/run"]
