#!/bin/bash

# Set the target directory for the clone
TARGET_DIR="/config"

# Check if the directory exists and is a git repository
if [ ! -d "${TARGET_DIR}/.git" ]; then
  echo "Repository not found in ${TARGET_DIR}. Cloning..."
  git clone https://github.com/username/repository.git "${TARGET_DIR}"
else
  echo "Repository already exists in ${TARGET_DIR}. Skipping clone."
fi

npm --prefix ${TARGET_DIR} install

NODE_IP=$(hostname -I | awk '{print $1}')

echo "**** Configuring /config/.env ****"
cat <<EOF > /config/.env
HOST=${NODE_IP}
PORT=8080
LINSTOR_API_HOST=${CONTROLLER_IP}:${CONTROLLER_PORT}
GATEWAY_API_HOST=${GATEWAY_IP}:${GATEWAY_PORT}
VSAN_API_HOST=${VSAN_IP}:${VSAN_PORT}
EOF
