FROM amazonlinux:2017.03
MAINTAINER Ben Jones <ben@fogbutter.com>

ARG PYTHON_VERSION=3.6.2
ARG PGSQL_VERSION=9.6.5
ARG PSYCOPG2_VERSION=2.7.3.1

# More concerned about readability than image size in this case so using
# mulitple runs.

# Install nessecary OS packages
RUN yum install -y gcc openssl-devel bzip2

# Download/build/install Python
RUN cd /usr/local/src &&\
    curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz &&\
    tar -xzf Python-${PYTHON_VERSION}.tgz &&\
    cd Python-${PYTHON_VERSION} &&\
    ./configure && make && make altinstall

# Download/build/install PostgreSQL
RUN cd /usr/local/src &&\
    curl -O https://ftp.postgresql.org/pub/source/v${PGSQL_VERSION}/postgresql-${PGSQL_VERSION}.tar.bz2 &&\
    tar -xjf postgresql-${PGSQL_VERSION}.tar.bz2 &&\
    cd postgresql-${PGSQL_VERSION} &&\
    ./configure --with-openssl --without-readline --without-zlib &&\
    make && make install

# Download the source for psycopg2-2.7.3.1 and extract it
RUN cd /usr/local/src &&\
    curl -L -O http://initd.org/psycopg/tarballs/PSYCOPG-2-7/psycopg2-${PSYCOPG2_VERSION}.tar.gz &&\
    tar -xzf psycopg2-${PSYCOPG2_VERSION}.tar.gz

# Change psycopg2's setup.cfg so that libpq will be staticly linked
RUN cd /usr/local/src/psycopg2-${PSYCOPG2_VERSION} &&\
    sed -r -i 's@static_libpq ?=.*@static_libpq = 1@g' setup.cfg &&\
    sed -r -i 's@libraries ?=.*@libraries = ssl crypto@g' setup.cfg &&\
    sed -r -i 's@pg_config ?= .*@pg_config = /usr/local/pgsql/bin/pg_config@g' setup.cfg &&\
    cat setup.cfg

# Build psycopg2, remove tests, and archive build dir to /usr/local/src
RUN cd /usr/local/src/psycopg2-${PSYCOPG2_VERSION} &&\
    python3.6 setup.py build &&\
    rm -r build/lib.linux-x86_64-3.6/psycopg2/tests &&\
    cd /usr/local/src &&\
    tar -czf python-${PYTHON_VERSION}_psycopg2-${PSYCOPG2_VERSION}_postgresql-${PGSQL_VERSION}_amazonlinux.tar.gz -C psycopg2-${PSYCOPG2_VERSION}/build/lib.linux-x86_64-3.6 psycopg2
