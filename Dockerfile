FROM registry.access.redhat.com/ubi8/python-39

USER root

RUN yum install -y \
        gcc make automake autoconf libtool \
        sqlite-devel curl \
    && yum clean all

# Copia todo el código fuente al contenedor
COPY . /opt/app-root/src

# Instala pip y las dependencias listadas en requirements.txt
RUN python3 -m ensurepip && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install -r /opt/app-root/src/requirements.txt

RUN chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src

WORKDIR /opt/app-root/src

ENV PATH=$PATH:/root/.local/bin \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONUNBUFFERED=1

USER 1001

CMD ["sh", "-c", "python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]
