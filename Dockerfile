FROM nvidia/cuda:12.3.0-runtime-ubuntu22.04

LABEL maintainer="Will Mobley"

USER root

EXPOSE 8888

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    fonts-liberation \
    git \
    locales \
    pandoc \
    python3 \
    python3-pip \
    ssh \
    yasm\
    wget \
    unzip \
    tar\
    vim \
    build-essential \
    rsync \
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/ffmpeg/7:7.0.1-5ubuntu2/ffmpeg_7.0.1.orig.tar.xz 

RUN  tar -xJf ffmpeg_7.0.1.orig.tar.xz
RUN ./ffmpeg-7.0.1/configure && make && make install

RUN pip install --upgrade --no-cache-dir \
    pip \
    setuptools \
    wheel
RUN pip install pipx


RUN pip install insanely-fast-whisper

ENTRYPOINT [ "insanely-fast-whisper"  ] 



