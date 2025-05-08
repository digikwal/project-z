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
ENV INSTALL_DIR="/opt/pzserver"
ENV HOME="/home/${USER}"
ENV PZ_HOME="${HOME}/Zomboid"
ENV STEAM_DIR="${HOME}/Steam"
ENV PZ_CACHE="${PZ_HOME}/Cache"
ENV PZ_CMD="${STEAM_DIR}/steamcmd.sh"
ENV PZ_MODS="${PZ_HOME}/Mods"
ENV PZ_SAVES="${PZ_HOME}/Saves"
ENV PZ_SERVER="${PZ_HOME}/Server"
ENV PZ_TEMPLATE="${PZ_SERVER}/template.ini"
ENV PZ_UPDATE="${PZ_HOME}/pzserver.txt"
ENV PZ_VERSION="41.78.16"
ENV PATH="${PATH}:/usr/games"
ENV LD_PRELOAD="${INSTALL_DIR}/jre64/lib/libjsig.so"
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
    mkdir -p "${STEAM_DIR}" && \
    curl -sqL "${STEAM_URL}" | tar -xzf - -C "${STEAM_DIR}" && \
    mkdir -p "${HOME}/.steam/sdk32" "${HOME}/.steam/sdk64" && \
    ln -s "${STEAM_DIR}/linux32/steamclient.so" "${HOME}/.steam/sdk32/steamclient.so" && \
    ln -s "${STEAM_DIR}/linux64/steamclient.so" "${HOME}/.steam/sdk64/steamclient.so" && \
    ln -s "${STEAM_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" && \
    chown -R "${USER}:${USER}" "${HOME}/.steam" "${STEAM_DIR}" && \
    rm -rf /var/lib/apt/lists/*

#----------------------------------------
# Zomboid setup and server installation
#----------------------------------------
FROM base-steamcmd AS image-projectz

WORKDIR ${HOME}

#----------------------------------------
# Directory Setup and Update Script
#----------------------------------------
COPY ../scripts/template.ini ${PZ_TEMPLATE}
RUN mkdir -p "${INSTALL_DIR}" "${PZ_HOME}" "${PZ_CACHE}" "${PZ_MODS}" "${PZ_SAVES}" "${PZ_SERVER}" && \
    echo '@ShutdownOnFailedCommand 1'        >  "${PZ_UPDATE}" && \
    echo '@NoPromptForPassword 1'            >> "${PZ_UPDATE}" && \
    echo "force_install_dir ${INSTALL_DIR}"  >> "${PZ_UPDATE}" && \
    echo 'login anonymous'                   >> "${PZ_UPDATE}" && \
    echo 'app_update 380870 validate'        >> "${PZ_UPDATE}" && \
    echo 'quit'                              >> "${PZ_UPDATE}" && \
    chown -R "${USER}:${USER}" "${INSTALL_DIR}" "${PZ_HOME}"

#----------------------------------------
# Entrypoint Script
#----------------------------------------
COPY --chown=pzuser:pzuser docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

#----------------------------------------
# Install Project Zomboid Server
#----------------------------------------
USER ${USER}
RUN "$PZ_CMD" +runscript "$PZ_UPDATE"

#----------------------------------------
# Container Entrypoint
#----------------------------------------
ENTRYPOINT ["/entrypoint.sh"]