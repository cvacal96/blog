FROM registry.access.redhat.com/ubi8/python-39

USER root

RUN yum install -y \
        gcc make automake autoconf libtool \
        sqlite-devel curl \
    && yum clean all

# Copia todo el código fuente directamente (sin usar S2I)
COPY . /opt/app-root/src

RUN chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

WORKDIR /opt/app-root/src

ENV PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONUNBUFFERED=1

USER 1001

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
