#!/usr/bin/env bash

BOLD='\033[0;1m'

printf "$${BOLD}Installing filebrowser \n\n"

# Check if filebrowser is installed
if ! command -v filebrowser &> /dev/null; then
  curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
fi

printf "🥳 Installation complete! \n\n"

printf "👷 Starting filebrowser in background... \n\n"

ROOT_DIR=${FOLDER}
ROOT_DIR=$${ROOT_DIR/\~/$HOME}

DB_FLAG=""
if [ "${DB_PATH}" != "filebrowser.db" ]; then
  DB_FLAG=" -d ${DB_PATH}"
fi

if test -f ${DB_PATH}; then
  printf "DB ${DB_PATH} is existing, skipping initializing"
else
  printf "DB ${DB_PATH} not existing, initializing"
  filebrowser ${DB_FLAG} config init
fi

printf "Setting baseurl to ${SERVER_BASE_PATH}"
filebrowser config set --baseurl "${SERVER_BASE_PATH}" ${DB_FLAG} > ${LOG_PATH} 2>&1

printf "📂 Serving $${ROOT_DIR} at http://localhost:${PORT} \n\n"

printf "Running 'filebrowser --noauth --root $ROOT_DIR --port ${PORT}$${DB_FLAG}' \n\n"

filebrowser --noauth --root $ROOT_DIR --port ${PORT}$${DB_FLAG} -b ${SERVER_BASE_PATH} >> ${LOG_PATH} 2>&1 &


printf "📝 Logs at ${LOG_PATH} \n\n"
