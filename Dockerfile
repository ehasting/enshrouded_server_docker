# --------------------------
# Base Image
# --------------------------
FROM docker.io/library/ubuntu:24.04

# --------------------------
# General Environment Variables
# --------------------------
ENV DEBIAN_FRONTEND="noninteractive"
ENV WINEARCH="win64"

# --------------------------
# Enshrouded Server Configuration
# --------------------------
ENV ENSHROUDED_SERVER_NAME="Enshrouded Server"
ENV ENSHROUDED_SERVER_MAXPLAYERS=16
ENV ENSHROUDED_VOICE_CHAT_MODE="Proximity"
ENV ENSHROUDED_ENABLE_VOICE_CHAT=false
ENV ENSHROUDED_ENABLE_TEXT_CHAT=false
ENV ENSHROUDED_GAME_PRESET="Default"
ENV ENSHROUDED_ADMIN_PW="AdminXXXXXXXX"
ENV ENSHROUDED_FRIEND_PW="FriendXXXXXXXX"
ENV ENSHROUDED_GUEST_PW="GuestXXXXXXXX"

# --------------------------
# Install Essential Packages
# --------------------------
RUN set -x \
&& apt update \
&& apt upgrade -y \
&& apt install -y \
    vim \
    wget \
    software-properties-common \
    locales \
    tini \
&& locale-gen en_US.UTF-8 \
&& update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# --------------------------
# Install SteamCMD and Dependencies
# --------------------------
RUN add-apt-repository -y multiverse \
&& dpkg --add-architecture i386 \
&& apt update \
&& echo steam steam/question select "I AGREE" | debconf-set-selections && echo steam steam/license note '' | debconf-set-selections \
&& apt install -y \
    lib32z1 \
    lib32gcc-s1 \
    lib32stdc++6 \
    steamcmd 


# --------------------------
# Install Wine and Winetricks
# --------------------------
RUN dpkg --add-architecture amd64 \
&& mkdir -pm755 /etc/apt/keyrings \
&& wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
&& wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources \
&& apt update \
&& apt install -y --install-recommends \
    winehq-staging \
&& apt install -y --allow-unauthenticated \
    cabextract \
    winbind \
    screen \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*


# --------------------------
# Add Entrypoint Script
# --------------------------
ADD ./entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# --------------------------
# Prepare SteamCMD Environment
# --------------------------
#RUN /usr/games/steamcmd +quit
WORKDIR /data

# --------------------------
# Volume and Port Configuration
# --------------------------
VOLUME /data
EXPOSE 15637/udp

# --------------------------
# Default Entrypoint
# --------------------------
ENTRYPOINT [ "/usr/bin/tini", "--", "/app/entrypoint.sh" ]
