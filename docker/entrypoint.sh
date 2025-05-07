#!/bin/bash
set -e

echo "Starting Project Zomboid Server..."
echo "SERVER_DIR=${SERVER_DIR}"
echo "SERVER_NAME=${SERVER_NAME}"

# Controleren of het startscript bestaat
if [[ ! -f "${SERVER_DIR}/start-server.sh" ]]; then
  echo "Error: ${SERVER_DIR}/start-server.sh does not exist!"
  exit 1
fi

# Start de server
exec "${SERVER_DIR}/start-server.sh" -servername "${SERVER_NAME}"
