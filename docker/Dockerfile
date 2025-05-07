#----------------------------------------
# Build Stage: Install dependencies and SteamCMD
#----------------------------------------
    FROM ubuntu:noble AS build-stage

    LABEL maintainer="digikwal"
    
    ARG PUID=1000
    RUN if [ -z "${PUID}" ]; then echo "Error: PUID is not set!" && exit 1; fi
    
    ENV USER=pzuser
    ENV DEBIAN_FRONTEND=noninteractive
    ENV HOME_DIR="/home/${USER}"
    ENV STEAM_DIR="${HOME_DIR}/steam"
    ENV SERVER_DIR="/opt/pzserver"
    ENV PATH="${PATH}:/usr/games"
    ENV STEAM_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
    
    RUN set -x \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
            lib32stdc++6 \
            lib32gcc-s1 \
            ca-certificates \
            curl \
            locales \
            nano \
        && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
        && dpkg-reconfigure --frontend=noninteractive locales \
        && useradd -u "${PUID}" -m "${USER}" \
        && mkdir -p "${STEAM_DIR}" \
        && curl -sqL "${STEAM_URL}" | tar zxvf - -C "${STEAM_DIR}" \
        && mkdir -p "${HOME_DIR}/.steam/sdk32" "${HOME_DIR}/.steam/sdk64" \
        && ln -s "${STEAM_DIR}/linux32/steamclient.so" "${HOME_DIR}/.steam/sdk32/steamclient.so" \
        && ln -s "${STEAM_DIR}/linux64/steamclient.so" "${HOME_DIR}/.steam/sdk64/steamclient.so" \
        && ln -s "${STEAM_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
        && chown -R "${USER}:${USER}" "${HOME_DIR}/.steam" "${STEAM_DIR}" \
        && rm -rf /var/lib/apt/lists/*
    
    #----------------------------------------
    # Base Builder Stage
    #----------------------------------------
    FROM build-stage AS base-builder
    WORKDIR ${STEAM_DIR}
    
    #----------------------------------------
    # Final Stage: Add Project Zomboid
    #----------------------------------------
    FROM base-builder AS steamcmd-base
    
    USER ${USER}
    ENV HOME=${HOME_DIR}
    ENV SERVER_SETTINGS="${HOME}/update_pzserver.txt"
    WORKDIR ${HOME}
    
    # Server configuration
    COPY Zomboid $HOME/Zomboid
    RUN mkdir -p "${SERVER_DIR}" && \
        chown -R ${USER}:${USER} "${SERVER_DIR}" "${HOME}/Zomboid" && \
        chmod +x "${STEAM_DIR}/start-server.sh"
    
    # Add update_pzserver.txt and install the Zomboid server
    RUN mkdir -p $HOME/.steam && \
    echo "@ShutdownOnFailedCommand 1" > ${SERVER_SETTINGS} && \
    echo "@NoPromptForPassword 1" >> ${SERVER_SETTINGS} && \
    echo "force_install_dir /opt/pzserver" >> ${SERVER_SETTINGS} && \
    echo "login anonymous" >> ${SERVER_SETTINGS} && \
    echo "app_update 380870 validate" >> ${SERVER_SETTINGS} && \
    echo "quit" >> ${SERVER_SETTINGS}
    
    RUN bash $HOME/steam/steamcmd.sh +runscript ${SERVER_SETTINGS}
    
    # Expose required ports for Project Zomboid
    EXPOSE 16261/udp
    EXPOSE 16262/udp
    
    # Default startup command
    CMD bash /opt/pzserver/start-server.sh -servername "${SERVER_NAME}"
