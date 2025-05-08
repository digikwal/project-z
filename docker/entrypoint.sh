#!/bin/bash
set -e

export PZ_INI="${HOME}/Zomboid/Server/${SERVER_NAME}.ini"

echo "Starting Project Zomboid Server..."
echo "INSTALL_DIR=${INSTALL_DIR}"
echo "SERVER_NAME=${SERVER_NAME}"
echo "PZ_INI=${PZ_INI}"

if [[ ! -f "${INSTALL_DIR}/start-server.sh" ]]; then
  echo "Error: ${INSTALL_DIR}/start-server.sh does not exist!"
  exit 1
fi

# Initialize args array
ARGS=()

# Optional arguments
[[ -n "$SERVER_NAME" ]] && ARGS+=(-servername "${SERVER_NAME}")
[[ -n "$MIN_RAM" ]] && ARGS+=(-Xms"$MIN_RAM")
[[ -n "$MAX_RAM" ]] && ARGS+=(-Xmx"$MAX_RAM")
[[ -n "$ADMIN_USERNAME" ]] && ARGS+=(-adminusername "$ADMIN_USERNAME")
[[ -n "$ADMIN_PASSWORD" ]] && ARGS+=(-adminpassword "$ADMIN_PASSWORD")
[[ -n "$BIND_IP" ]] && ARGS+=(-ip "$BIND_IP")
[[ -n "$DEFAULT_PORT" ]] && ARGS+=(-port "$DEFAULT_PORT")
[[ -n "$UDP_PORT" ]] && ARGS+=(-udpport "$UDP_PORT")
[[ "$STEAM_API" = "false" ]] && ARGS+=(-nosteam)
[[ -n "$STEAM_VAC" ]] && ARGS+=(-steamvac "$STEAM_VAC")
[[ -n "$CACHE_DIR" ]] && ARGS+=(-cachedir "$CACHE_DIR")
[[ -n "$STATISTIC" ]] && ARGS+=(-statistic "$STATISTIC")
[[ -n "$MODFOLDERS" ]] && ARGS+=(-modfolders "$MODFOLDERS")
[[ -n "$DEBUG_LOG" ]] && ARGS+=(-debuglog="$DEBUG_LOG")
[[ "$DEBUG" = "true" ]] && ARGS+=(-debug)
[[ "$SOFTRESET" = "true" ]] && ARGS+=(-Dsoftreset)
[[ "$COOP" = "true" ]] && ARGS+=(-coop)

# Server preset handling
if [[ -n "$SERVER_PRESET" ]]; then
  PRESET_PATH="${INSTALL_DIR}/media/lua/shared/Sandbox/${SERVER_PRESET}.lua"
  SERVER_SANDBOX_PATH="${HOME}/Zomboid/Server/${SERVER_NAME}_SandboxVars.lua"

  if [[ ! -f "$PRESET_PATH" ]]; then
    echo "Error: Preset ${SERVER_PRESET} does not exist!"
    exit 1
  elif [[ ! -f "$SERVER_SANDBOX_PATH" || "$SERVER_REPLACE" = "true" ]]; then
    echo "Using preset ${SERVER_PRESET} to create server configuration..."
    mkdir -p "$(dirname "$SERVER_SANDBOX_PATH")"
    cp -f "$PRESET_PATH" "$SERVER_SANDBOX_PATH"
    sed -i "1s/return.*/SandboxVars = {/" "$SERVER_SANDBOX_PATH"
    chmod 644 "$SERVER_SANDBOX_PATH"
  fi
fi

if [ -n "${MOD_ID}" ]; then
 	echo "*** INFO: Found Mods including ${MOD_ID} ***"
	sed -i "s/Mods=.*/Mods=${MOD_ID}/" "${PZ_INI}"
fi

if [ -n "${WORKSHOP_ID}" ]; then
 	echo "*** INFO: Found Workshop IDs including ${WORKSHOP_ID} ***"
	sed -i "s/WorkshopItems=.*/WorkshopItems=${WORKSHOP_ID}/" "${PZ_INI}"
	
fi

if [ -n "${MAP_NAME}" ]; then
 	echo "*** INFO: Loading map ${MAP_NAME} ***"
  sed -i "s/Map=.*/Map=${MAP_NAME}/" "${PZ_INI}"
fi

if [ -n "${SPAWN_POINT}" ]; then
 	echo "*** INFO: Spawning coordinates ${SPAWN_POINT} ***"
  sed -i "s/SpawnPoint=.*/SpawnPoint=${SPAWN_POINT}/" "${PZ_INI}"
fi

if [ -n "${AUTOSAVE_INTERVAL}" ]; then
 	echo "*** INFO: Loaded parts of the map are saved every ${AUTOSAVE_INTERVAL} minutes ***"
  sed -i "s/SaveWorldEveryMinutes=.*/SaveWorldEveryMinutes=${AUTOSAVE_INTERVAL}/" "${PZ_INI}"
fi

if [ -n "${PUBLIC_SERVER}" ]; then
  if [ "${PUBLIC_SERVER}" = "true" ]; then
    echo "*** INFO: This server is public ***"
  else
    echo "*** INFO: This server is private ***"
  fi
  sed -i "s/Public=.*/Public=${PUBLIC_SERVER}/" "${PZ_INI}"
fi

if [ -n "${DISPLAY_NAME}" ]; then
 	echo "*** INFO: Server display name is set to ${DISPLAY_NAME} ***"
  sed -i "s/PublicName=.*/PublicName=${DISPLAY_NAME}/" "${PZ_INI}"
fi

if [ -n "${SERVER_DESCRIPTION}" ]; then
 	echo "*** INFO: Server description loaded succesfully ${SERVER_DESCRIPTION} ***"
  sed -i "s/PublicDescription=.*/PublicDescription=${SERVER_DESCRIPTION}/" "${PZ_INI}"
fi

if [ -n "${MAX_PLAYERS}" ]; then
 	echo "*** INFO: Maximum players allowed on server ${MAX_PLAYERS} ***"
  sed -i "s/MaxPlayers=.*/MaxPlayers=${MAX_PLAYERS}/" "${PZ_INI}"
fi

if [ -n "${PVP}" ]; then
  if [ "${PVP}" = "true" ]; then
    echo "*** INFO: PVP is enabled ***"
  else
    echo "*** INFO: PVP is disabled ***"
  fi
  sed -i "s/PVP=.*/PVP=${PVP}/" "${PZ_INI}"
fi

if [ -n "${PAUSE}" ]; then
  if [ "${PAUSE}" = "true" ]; then
    echo "*** INFO: Game time stops when there are no players online ***"
  else
    echo "*** INFO: Game time continues when there are no players online ***"
  fi
  sed -i "s/PauseEmpty=.*/PauseEmpty=${PAUSE}/" "${PZ_INI}"
fi

if [ -n "${DEATH_MSG}" ]; then
  if [ "${DEATH_MSG}" = "true" ]; then
    echo "*** INFO: Player deaths are messaged globally ***"
  else
    echo "*** INFO: Player deaths are not messaged globally ***"
  fi
  sed -i "s/AnnounceDeath=.*/AnnounceDeath=${DEATH_MSG}/" "${PZ_INI}"
fi

if [ -n "${RCON_PASSWORD}" ]; then
  MASKED_PASSWORD="${RCON_PASSWORD:0:2}******${RCON_PASSWORD: -2}" # Show first 2 and last 2 characters
  echo "*** INFO: Remote console password set (${MASKED_PASSWORD}) ***"
  sed -i "s/RCONPassword=.*/RCONPassword=${RCON_PASSWORD}/" "${PZ_INI}"
fi

if [ -n "${RCON_PORT}" ]; then
 	echo "*** INFO: Remote console port set ${RCON_PORT} ***"
  sed -i "s/RCONPort=.*/RCONPort=${RCON_PORT}/" "${PZ_INI}"
fi

if [ -n "${VOIP}" ]; then
  if [ "${VOIP}" = "true" ]; then
    echo "*** INFO: VOIP is enabled ***"
  else
    echo "*** INFO: VOIP is disabled ***"
  fi
  sed -i "s/VoiceEnable=.*/VoiceEnable=${VOIP}/" "${PZ_INI}"
fi

# Steam servers require two additional ports to function
# Must be unique from DefaultPort value
# Use STEAMPORT1 and STEAMPORT2 variables in your compose file
[[ -n "$STEAMPORT_1" ]] && ARGS+=(-steamport1 "$STEAMPORT_1")
[[ -n "$STEAMPORT_2" ]] && ARGS+=(-steamport2 "$STEAMPORT_2")
[[ -n "$SERVER_PASSWORD" ]] && ARGS+=(+password "$SERVER_PASSWORD")

# Start the server
exec "${INSTALL_DIR}/start-server.sh" "${ARGS[@]}"