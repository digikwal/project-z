#!/bin/bash
set -e

export LD_PRELOAD="${INSTALL_DIR}/jre64/lib/libjsig.so"

if [[ ! -f "${INSTALL_DIR}/start-server.sh" ]]; then
  echo "Error: ${INSTALL_DIR}/start-server.sh does not exist!"
  exit 1
fi

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
# Server preset handling
#------------------------------
if [[ -n "${SERVER_PRESET}" ]]; then
  SETUP_INI="${PZ_TEMPLATE}"
  SETUP_PRESET="${INSTALL_DIR}/media/lua/shared/Sandbox/${SERVER_PRESET}.lua"
  INSTALL_INI="${PZ_SERVER}/${SERVER_NAME}.ini"
  INSTALL_PRESET="${PZ_SERVER}/${SERVER_NAME}_SandboxVars.lua"
  INSTALL_SPAWN="${PZ_SERVER}/${SERVER_NAME}_spawnregions.lua"

  if [[ ! -f "${SETUP_INI}" || ! -s "${SETUP_INI}" ]]; then
    echo "Error: ${SETUP_INI} does not exist or is empty. Please provide a valid server configuration template." >&2
    exit 1
  fi

  if [[ "${SETUP_INI}" != "${INSTALL_INI}" ]]; then
    echo "Renaming ${SETUP_INI} to ${INSTALL_INI}..."
    mkdir -p "$(dirname "${INSTALL_INI}")"
    mv "${SETUP_INI}" "${INSTALL_INI}"
    chmod 644 "${INSTALL_INI}"
  fi

  if [[ ! -f "${INSTALL_PRESET}" || ! -s "${INSTALL_PRESET}" ]]; then
    echo "Copying preset file from ${SETUP_PRESET} to ${INSTALL_PRESET}..."
    mkdir -p "$(dirname "${INSTALL_PRESET}")"
    cp "${SETUP_PRESET}" "${INSTALL_PRESET}"
    chmod 644 "${INSTALL_PRESET}"
  fi

  if [[ ! -f "${INSTALL_SPAWN}" || ! -s "${INSTALL_SPAWN}" ]]; then
    echo "Creating default spawn regions file at ${INSTALL_SPAWN}..."
    mkdir -p "$(dirname "${INSTALL_SPAWN}")"
    cat > "${INSTALL_SPAWN}" <<EOF
function SpawnRegions()
  return {
    { name = "Muldraugh, KY", file = "media/maps/Muldraugh, KY/spawnpoints.lua" },
    { name = "Riverside, KY", file = "media/maps/Riverside, KY/spawnpoints.lua" },
    { name = "Rosewood, KY", file = "media/maps/Rosewood, KY/spawnpoints.lua" },
    { name = "West Point, KY", file = "media/maps/West Point, KY/spawnpoints.lua" },
  }
end
EOF
    chmod 644 "${INSTALL_SPAWN}"
  fi
fi

#------------------------------
# Server configuration handling
#------------------------------
if [ -n "${MOD_ID}" ]; then
 	echo "*** INFO: Found Mods including ${MOD_ID} ***"
	sed -i "s/Mods=.*/Mods=${MOD_ID}/" "${INSTALL_INI}"
fi

if [ -n "${WORKSHOP_ID}" ]; then
 	echo "*** INFO: Found Workshop IDs including ${WORKSHOP_ID} ***"
	sed -i "s/WorkshopItems=.*/WorkshopItems=${WORKSHOP_ID}/" "${INSTALL_INI}"
	
fi

if [ -n "${MAP_NAME}" ]; then
 	echo "*** INFO: Loading map ${MAP_NAME} ***"
  sed -i "s/Map=.*/Map=${MAP_NAME}/" "${INSTALL_INI}"
fi

if [ -n "${SPAWN_POINT}" ]; then
 	echo "*** INFO: Spawning coordinates ${SPAWN_POINT} ***"
  sed -i "s/SpawnPoint=.*/SpawnPoint=${SPAWN_POINT}/" "${INSTALL_INI}"
fi

if [ -n "${AUTOSAVE_INTERVAL}" ]; then
 	echo "*** INFO: Loaded parts of the map are saved every ${AUTOSAVE_INTERVAL} minutes ***"
  sed -i "s/SaveWorldEveryMinutes=.*/SaveWorldEveryMinutes=${AUTOSAVE_INTERVAL}/" "${INSTALL_INI}"
fi

if [ -n "${PUBLIC_SERVER}" ]; then
  if [ "${PUBLIC_SERVER}" = "true" ]; then
    echo "*** INFO: This server is public ***"
  else
    echo "*** INFO: This server is private ***"
  fi
  sed -i "s/Public=.*/Public=${PUBLIC_SERVER}/" "${INSTALL_INI}"
fi

if [ -n "${DISPLAY_NAME}" ]; then
 	echo "*** INFO: Server display name is set to ${DISPLAY_NAME} ***"
  sed -i "s/PublicName=.*/PublicName=${DISPLAY_NAME}/" "${INSTALL_INI}"
fi

if [ -n "${SERVER_DESCRIPTION}" ]; then
 	echo "*** INFO: Server description loaded succesfully ${SERVER_DESCRIPTION} ***"
  sed -i "s/PublicDescription=.*/PublicDescription=${SERVER_DESCRIPTION}/" "${INSTALL_INI}"
fi

if [ -n "${MAX_PLAYERS}" ]; then
 	echo "*** INFO: Maximum players allowed on server ${MAX_PLAYERS} ***"
  sed -i "s/MaxPlayers=.*/MaxPlayers=${MAX_PLAYERS}/" "${INSTALL_INI}"
fi

if [ -n "${PVP}" ]; then
  if [ "${PVP}" = "true" ]; then
    echo "*** INFO: PVP is enabled ***"
  else
    echo "*** INFO: PVP is disabled ***"
  fi
  sed -i "s/PVP=.*/PVP=${PVP}/" "${INSTALL_INI}"
fi

if [ -n "${PAUSE}" ]; then
  if [ "${PAUSE}" = "true" ]; then
    echo "*** INFO: Game time stops when there are no players online ***"
  else
    echo "*** INFO: Game time continues when there are no players online ***"
  fi
  sed -i "s/PauseEmpty=.*/PauseEmpty=${PAUSE}/" "${INSTALL_INI}"
fi

if [ -n "${DEATH_MSG}" ]; then
  if [ "${DEATH_MSG}" = "true" ]; then
    echo "*** INFO: Player deaths are messaged globally ***"
  else
    echo "*** INFO: Player deaths are not messaged globally ***"
  fi
  sed -i "s/AnnounceDeath=.*/AnnounceDeath=${DEATH_MSG}/" "${INSTALL_INI}"
fi

if [ -n "${SERVER_PASSWORD}" ]; then
  SERVER_MASKED="${SERVER_PASSWORD:0:2}******${SERVER_PASSWORD: -2}"
  echo "*** INFO: Remote console password set (${SERVER_MASKED}) ***"
  sed -i "s/RCONPassword=.*/RCONPassword=${SERVER_PASSWORD}/" "${INSTALL_INI}"
fi

if [ -n "${RCON_PORT}" ]; then
 	echo "*** INFO: Remote console port set ${RCON_PORT} ***"
  sed -i "s/RCONPort=.*/RCONPort=${RCON_PORT}/" "${INSTALL_INI}"
fi

if [ -n "${RCON_PASSWORD}" ]; then
  RCON_MASKED="${RCON_PASSWORD:0:2}******${RCON_PASSWORD: -2}"
  echo "*** INFO: Remote console password set (${RCON_MASKED}) ***"
  sed -i "s/RCONPassword=.*/RCONPassword=${RCON_PASSWORD}/" "${INSTALL_INI}"
fi

if [ -n "${RCON_PORT}" ]; then
 	echo "*** INFO: Remote console port set ${RCON_PORT} ***"
  sed -i "s/RCONPort=.*/RCONPort=${RCON_PORT}/" "${INSTALL_INI}"
fi

if [ -n "${VOIP}" ]; then
  if [ "${VOIP}" = "true" ]; then
    echo "*** INFO: VOIP is enabled ***"
  else
    echo "*** INFO: VOIP is disabled ***"
  fi
  sed -i "s/VoiceEnable=.*/VoiceEnable=${VOIP}/" "${INSTALL_INI}"
fi


#------------------------------
# Start the server with Java args first, followed by "--" and game args
#------------------------------
exec "${INSTALL_DIR}/start-server.sh" "${JAVA_ARGS[@]}" -- "${GAME_ARGS[@]}"