ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION

ARG UBUNTU_VERSION=latest
# i386 is required until the day `steamcmd` is built for amd64 and also games no longer need i386 libs.
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get upgrade -y \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && apt-get install -y ca-certificates steamcmd locales \
    && locale-gen en_US.UTF-8 \
    && if [ -n "$(echo $UBUNTU_VERSION | grep -e focal -e bionic)" ]; then \
        apt install -y lib32gcc1; else apt install -y lib32gcc-s1; fi \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

RUN ln -s /usr/games/steamcmd /usr/local/bin
RUN useradd -m steam

WORKDIR /home/steam
USER steam

# install steamcmd and remove downloaded packages to reduce image size
RUN steamcmd +quit \
    && rm -rf /home/steam/.local/share/Steam/steamcmd/package/*.zip.*
