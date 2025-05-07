#----------------------------------------
# Build Stage: Install dependencies and SteamCMD
#----------------------------------------
    FROM ubuntu:noble AS build-stage

    LABEL maintainer="digikwal"
    
    ARG PUID=1000
    RUN if [ -z "${PUID}" ]; then echo "Error: PUID is not set!" && exit 1; fi
    
    ENV USER=pzuser
    ENV DEBIAN_FRONTEND=noninteractive
    ENV HOME="/home/${USER}"
    ENV STEAM_DIR="${HOME}/steam"
    ENV SERVER_DIR="/opt/pzserver"
    ENV SERVER_NAME="default"
    ENV PATH="${PATH}:/usr/games"
    ENV PZSERVER="${HOME}/Zomboid/pzserver.txt"
    ENV STEAM_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
    
    RUN set -x && \
        apt-get update && \
        apt-get install -y --no-install-recommends --no-install-suggests \
            lib32stdc++6 \
            lib32gcc-s1 \
            ca-certificates \
            curl \
            locales \
            nano && \
        sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        useradd -u "${PUID}" -m "${USER}" && \
        mkdir -p "${STEAM_DIR}" && \
        curl -sqL "${STEAM_URL}" | tar zxvf - -C "${STEAM_DIR}" && \
        mkdir -p "${HOME}/.steam/sdk32" "${HOME}/.steam/sdk64" && \
        ln -s "${STEAM_DIR}/linux32/steamclient.so" "${HOME}/.steam/sdk32/steamclient.so" && \
        ln -s "${STEAM_DIR}/linux64/steamclient.so" "${HOME}/.steam/sdk64/steamclient.so" && \
        ln -s "${STEAM_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" && \
        chown -R "${USER}:${USER}" "${HOME}/.steam" "${STEAM_DIR}" && \
        rm -rf /var/lib/apt/lists/*

    #----------------------------------------
    # Base Builder Stage
    #----------------------------------------
    FROM build-stage AS base-builder
    WORKDIR ${STEAM_DIR}

    #----------------------------------------
    # Final Stage: Add Project Zomboid
    #----------------------------------------
    FROM base-builder AS steamcmd-base

    WORKDIR ${HOME}

    # Create the server directory and set permissions as root
    RUN mkdir -p "${SERVER_DIR}" && \
        chown -R ${USER}:${USER} "${SERVER_DIR}"

    # Server configuration
    COPY Zomboid $HOME/Zomboid
    RUN chown -R ${USER}:${USER} "${HOME}/Zomboid"

    # Run SteamCMD install as root (ensure permissions are OK first)
    RUN bash $HOME/steam/steamcmd.sh +runscript ${PZSERVER} && \
        chown -R ${USER}:${USER} ${SERVER_DIR}

    # Copy entrypoint and make it executable
    COPY docker/entrypoint.sh /entrypoint.sh
    RUN chmod +x /entrypoint.sh
    
    # Switch to the non-root user
    USER ${USER}

    # Set entrypoint
    ENTRYPOINT ["/entrypoint.sh"]

    # Expose required ports for Project Zomboid
    EXPOSE 16261/udp
    EXPOSE 16262/udp
    EXPOSE 27015/tcp
