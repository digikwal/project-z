#----------------------------------------
# Dockerfile for Project Zomboid Server
#----------------------------------------
FROM ubuntu:noble AS base-steamcmd

#----------------------------------------
# Set initial build-time arguments
#----------------------------------------
ARG PUID=2000

#----------------------------------------
# Image Information and Labels
#----------------------------------------
LABEL org.opencontainers.image.authors="digikwal" \
    org.opencontainers.image.url="https://hub.docker.com/r/digikwal/project-z" \
    org.opencontainers.image.documentation="https://github.com/digikwal/project-z" \
    org.opencontainers.image.title="project-z" \
    org.opencontainers.image.description="Dockerized Project Zomboid server for hosting with minimal effort." \
    org.opencontainers.image.licenses="GPL-3.0" \
    org.opencontainers.image.source="https://github.com/digikwal/project-z"

#----------------------------------------
# Environment Setup
#----------------------------------------
ENV USER=pzuser
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV HOME="/home/${USER}"
ENV DIR_PZ="${HOME}/Zomboid"
ENV DIR_CACHE="${DIR_PZ}/Cache"
ENV DIR_INSTALL="/opt/pzserver"
ENV DIR_MODS="${DIR_PZ}/Mods"
ENV DIR_SAVES="${DIR_PZ}/Saves"
ENV DIR_SCRIPTS="${DIR_PZ}/Scripts"
ENV DIR_SERVER="${DIR_PZ}/Server"
ENV DIR_STEAM="${HOME}/Steam"
ENV FILE_CMD="${DIR_STEAM}/steamcmd.sh"
ENV FILE_CONFIG="${DIR_SCRIPTS}/server_config.sh"
ENV FILE_ENTRY="/entrypoint.sh"
ENV FILE_PRESET="${DIR_SCRIPTS}/server_preset.sh"
ENV FILE_TEMPLATE="${DIR_SERVER}/template.ini"
ENV FILE_UPDATE="${DIR_PZ}/pzserver.txt"
ENV FILE_WORLD="${DIR_SCRIPTS}/world_config.sh"
ENV PATH="${PATH}:/usr/games"
ENV PZ_VERSION="41.78.16"
ENV STEAM_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"

#----------------------------------------
# System Setup and SteamCMD Installation
#----------------------------------------
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        openjdk-11-jre-headless \
        lib32stdc++6 \
        lib32gcc-s1 \
        ca-certificates \
        curl \
        locales \
        tmux \
        nano && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    { \
        echo "Initial PUID=${PUID}"; \
        if ! id -u "${PUID}" >/dev/null 2>&1; then \
            FINAL_PUID="${PUID}"; \
        else \
            FINAL_PUID=$(awk 'BEGIN{for(i=2000;i<65535;i++) if(system("id -u " i " >/dev/null 2>&1")) {print i; exit}}'); \
            echo "PUID=${PUID} is in use. Using next available PUID=${FINAL_PUID}"; \
        fi; \
        useradd -u "${FINAL_PUID}" -m -d "${HOME}" "${USER}"; \
    } && \
    mkdir -p "${DIR_STEAM}" && \
    curl -sqL "${STEAM_URL}" | tar -xzf - -C "${DIR_STEAM}" && \
    mkdir -p "${HOME}/.steam/sdk32" "${HOME}/.steam/sdk64" && \
    ln -s "${DIR_STEAM}/linux32/steamclient.so" "${HOME}/.steam/sdk32/steamclient.so" && \
    ln -s "${DIR_STEAM}/linux64/steamclient.so" "${HOME}/.steam/sdk64/steamclient.so" && \
    ln -s "${DIR_STEAM}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" && \
    chown -R "${USER}:${USER}" "${HOME}/.steam" "${DIR_STEAM}" && \
    rm -rf /var/lib/apt/lists/*

#----------------------------------------
# Zomboid setup and server installation
#----------------------------------------
FROM base-steamcmd AS image-projectz

WORKDIR ${HOME}

#----------------------------------------
# Directory Setup and Update Script
#----------------------------------------
COPY docker/entrypoint.sh ${FILE_ENTRY}
COPY scripts ${DIR_SCRIPTS}
RUN mkdir -p "${DIR_INSTALL}" "${DIR_CACHE}" "${DIR_MODS}" "${DIR_SAVES}" && \
    echo '@ShutdownOnFailedCommand 1'        >  "${FILE_UPDATE}" && \
    echo '@NoPromptForPassword 1'            >> "${FILE_UPDATE}" && \
    echo "force_install_dir ${DIR_INSTALL}"  >> "${FILE_UPDATE}" && \
    echo 'login anonymous'                   >> "${FILE_UPDATE}" && \
    echo 'app_update 380870 validate'        >> "${FILE_UPDATE}" && \
    echo 'quit'                              >> "${FILE_UPDATE}" && \
    chmod +x "${FILE_CONFIG}" "${FILE_ENTRY}" "${FILE_PRESET}" && \
    chown -R "${USER}:${USER}" "${FILE_ENTRY}" "${DIR_INSTALL}" "${DIR_PZ}"

#----------------------------------------
# Install Project Zomboid Server
#----------------------------------------
USER ${USER}
RUN "${FILE_CMD}" +runscript "${FILE_UPDATE}"

#----------------------------------------
# Container Entrypoint
#----------------------------------------
ENTRYPOINT ["/entrypoint.sh"]