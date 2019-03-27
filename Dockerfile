FROM ubuntu:xenial
MAINTAINER Thomas Kobber Panum <thomas@panum.dk>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q \
    && apt-get install -qy build-essential wget libfontconfig1 software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install TexLive with scheme-basic
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
	mkdir /install-tl-unx; \
	tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    echo "selected_scheme scheme-full" >> /install-tl-unx/texlive.profile; \
	/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
	rm install-tl-unx.tar.gz

RUN add-apt-repository -y ppa:kelleyk/emacs
RUN apt-get update -q \
    && apt-get install -qy emacs26 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/texlive/2018/bin/x86_64-linux:${PATH}"

ENV HOME /data
WORKDIR /data

RUN tlmgr install latexmk

VOLUME ["/data"]
