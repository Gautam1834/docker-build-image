FROM python:3-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
        git g++ gcc autoconf automake \
        m4 libtool qt4-qmake make libqt4-dev libcurl4-openssl-dev \
        libcrypto++-dev libsqlite3-dev libc-ares-dev \
        libsodium-dev libnautilus-extension-dev \
        libssl-dev libfreeimage-dev swig \
    && apt-get -y autoremove --purge \


# Installing mega sdk python binding
    && MEGA_SDK_VERSION="3.8.6" \
    && git clone https://github.com/meganz/sdk.git --depth=1 -b v$MEGA_SDK_VERSION ~/sdk \
    && cd ~/sdk \
    && rm -rf .git \
    && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && cd bindings/python/ \
    && python3 setup.py bdist_wheel \
    && cd dist/ \
    && pip3 install --no-cache-dir megasdk-$MEGA_SDK_VERSION-*.whl