#!/bin/bash
set -e

export LD_PRELOAD="${DIR_INSTALL}/jre64/lib/libjsig.so"

if [[ ! -f "${DIR_INSTALL}/start-server.sh" ]]; then
  echo "Error: ${DIR_INSTALL}/start-server.sh does not exist!"
  exit 1
fi

# Source preset first. 
# This ensures that any variables or files created by $FILE_PRESET are available when $FILE_CONFIG is sourced.
echo "Setting up server presets"
source "${FILE_PRESET}"

# Source config to allow customization of server ini through environment variables.
echo "Setting up server configuration"
source "${FILE_CONFIG}"

# Source dificulty to allow customization of server world through environment variables, e.g. WaterShutoff, ElecShutoff, etc.
echo "Setting up server difficulty"
source "${FILE_WORLD}"

echo "Starting Project Zomboid Server..."


#------------------------------
# Initialize args array
#------------------------------

JAVA_ARGS=()
GAME_ARGS=()


#------------------------------
# Java arguments
#------------------------------
[[ -n "${MIN_RAM}" ]] && JAVA_ARGS+=(-Xms"${MIN_RAM}")
[[ -n "${MAX_RAM}" ]] && JAVA_ARGS+=(-Xmx"${MAX_RAM}")
[[ "${STEAM_API}" = "true" ]] && JAVA_ARGS+=(-Dzomboid.steam=1)
[[ "${STEAM_API}" = "false" ]] && JAVA_ARGS+=(-Dzomboid.steam=0)
[[ -n "${CACHE_DIR}" ]] && JAVA_ARGS+=(-Ddeployment.user.cachedir="${CACHE_DIR}")
[[ "${SOFTRESET}" = "true" ]] && JAVA_ARGS+=(-Dsoftreset)
[[ "${DEBUG}" = "true" ]] && JAVA_ARGS+=(-Ddebug)


#------------------------------
# Game arguments
#------------------------------
[[ -n "${SERVER_NAME}" ]] && GAME_ARGS+=(-servername "${SERVER_NAME}")
[[ -n "${ADMIN_USERNAME}" ]] && GAME_ARGS+=(-adminusername "${ADMIN_USERNAME}")
[[ -n "${ADMIN_PASSWORD}" ]] && GAME_ARGS+=(-adminpassword "${ADMIN_PASSWORD}")
[[ -n "${BIND_IP}" ]] && GAME_ARGS+=(-ip "${BIND_IP}")
[[ -n "${DEFAULT_PORT}" ]] && GAME_ARGS+=(-port "${DEFAULT_PORT}")
[[ -n "${UDP_PORT}" ]] && GAME_ARGS+=(-udpport "${UDP_PORT}")
[[ -n "${STEAM_VAC}" ]] && GAME_ARGS+=(-steamvac "${STEAM_VAC}")
[[ -n "${DEBUG_LOG}" ]] && GAME_ARGS+=(-debuglog="${DEBUG_LOG}")
[[ "${COOP}" = "true" ]] && GAME_ARGS+=(-coop)

# Steam servers require two available ports to function
[[ -n "${STEAMPORT_1}" ]] && GAME_ARGS+=(-steamport1 "${STEAMPORT_1}")
[[ -n "${STEAMPORT_2}" ]] && GAME_ARGS+=(-steamport2 "${STEAMPORT_2}")


#------------------------------
# Start the server with Java args first, followed by "--" and game args
#------------------------------
exec "${DIR_INSTALL}/start-server.sh" "${JAVA_ARGS[@]}" -- "${GAME_ARGS[@]}"