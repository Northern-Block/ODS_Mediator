FROM ubuntu:16.04
USER root
RUN apt-get update && apt-get install -y gnupg2 \
    software-properties-common python3-pip cargo libzmq3-dev \
    libsodium-dev pkg-config libssl-dev curl

RUN apt-get update && apt-get install -y apt-transport-https

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    echo "deb https://repo.sovrin.org/sdk/deb xenial master" >> /etc/apt/sources.list && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic master" && \
    apt-get update && \
    apt-get install -y indy-cli && \
    apt-get install -y libindy && \
    pip3 install python3_indy && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get -y update && \
    apt-get -y install python3.9 python3.9-distutils && \
    rm -rvf /usr/bin/python && \
    ln -s /usr/bin/python3.9 /usr/bin/python && \
    rm -rvf /usr/bin/python3 && \
    ln -s /usr/bin/python3.9 /usr/bin/python3 && \
    apt-get install -y wget && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install aries-cloudagent && \
    pip install --ignore-installed PyYAML && \
    pip install qrcode && \
    pip install packaging

RUN apt-get install -y git && \
    git clone https://github.com/hyperledger/aries-cloudagent-python && \
    cd aries-cloudagent-python

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait
ENTRYPOINT ["/bin/bash", "-c", "/wait && /usr/local/bin/aca-py \"$@\"", "--"]