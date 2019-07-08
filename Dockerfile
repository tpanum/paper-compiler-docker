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
    echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile; \
	/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
	rm install-tl-unx.tar.gz

ENV PATH="/usr/local/texlive/2018/bin/x86_64-linux:${PATH}"
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh; \
    sh update-tlmgr-latest.sh

RUN add-apt-repository -y ppa:kelleyk/emacs
RUN apt-get update -q \
    && apt-get install -qy emacs26 \
    && rm -rf /var/lib/apt/lists/*


ENV HOME /data
WORKDIR /data

RUN ls /usr/local/texlive/
RUN tlmgr update --self --all
RUN tlmgr install latexmk ulem float wrapfig soul marvosym wasysym hyperref collection-fontsrecommended libertine texliveonfly

VOLUME ["/data"]
