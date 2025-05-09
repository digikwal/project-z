#!/bin/bash
set -e

#------------------------------
# Server preset handling
#------------------------------
if [[ -n "${SERVER_PRESET}" ]]; then
  SETUP_INI="${PZ_TEMPLATE}"
  SETUP_PRESET="${DIR_INSTALL}/media/lua/shared/Sandbox/${SERVER_PRESET}.lua"
  INSTALL_INI="${DIR_SERVER}/${SERVER_NAME}.ini"
  INSTALL_PRESET="${DIR_SERVER}/${SERVER_NAME}_SandboxVars.lua"
  INSTALL_SPAWN="${DIR_SERVER}/${SERVER_NAME}_spawnregions.lua"

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