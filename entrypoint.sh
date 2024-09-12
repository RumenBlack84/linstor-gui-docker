#!/bin/bash

# Set the target directory for the clone
TARGET_DIR="/config"

# Check if the directory exists and is a git repository
if [ ! -d "${TARGET_DIR}/.git" ]; then
  echo "Repository not found in ${TARGET_DIR}. Cloning..."
  git clone https://github.com/LINBIT/linstor-gui ${TARGET_DIR}
else
  echo "Repository already exists in ${TARGET_DIR}. Skipping clone."
fi

npm --prefix ${TARGET_DIR} install

NODE_IP=$(hostname -i | awk '{print $1}')

echo "**** Configuring /config/.env ****"
cat <<EOF > /config/.env
HOST=${NODE_IP}
PORT=8080
LINSTOR_API_HOST=${CONTROLLER_HOST}
GATEWAY_API_HOST=${GATEWAY_HOST}
VSAN_API_HOST=${VSAN_HOST}
EOF

# Pass control to the CMD instruction (npm start)
exec "$@"