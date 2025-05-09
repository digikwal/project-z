#!/bin/bash
set -e

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
  sed -i "s/Password==.*/Password==${SERVER_PASSWORD}/" "${INSTALL_INI}"
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

if [ -n "${UPNP}" ]; then
  if [ "${UPNP}" = "true" ]; then
    echo "*** INFO: UPNP is enabled ***"
  else
    echo "*** INFO: UPNP is disabled ***"
  fi
  sed -i "s/UPnP=.*/UPnP=${UPNP}/" "${INSTALL_INI}"
fi

if [ -n "${FACTION}" ]; then
  if [ "${FACTION}" = "true" ]; then
    echo "*** INFO: FACTION is enabled ***"
    
    echo "*** INFO: Players must survive this number of in-game days ${FACTION_MINDAY} ***"
    sed -i "s/FactionDaySurvivedToCreate=.*/FactionDaySurvivedToCreate=${FACTION_MINDAY}/" "${INSTALL_INI}"

    echo "*** INFO: Number of players required as faction members ${FACTION_MINREQ} ***"
    sed -i "s/FactionPlayersRequiredForTag=.*/FactionPlayersRequiredForTag=${FACTION_MINREQ}/" "${INSTALL_INI}"
  else
    echo "*** INFO: FACTION is disabled ***"
  fi
  sed -i "s/Faction=.*/Faction=${FACTION}/" "${INSTALL_INI}"
fi