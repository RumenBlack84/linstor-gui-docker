#!/bin/sh

NODE_IP=$(hostname -i | awk '{print $1}')

echo "**** Configuring .env ****"
cat <<EOF > .env
HOST=${NODE_IP}
PORT=8080
LINSTOR_API_HOST=${CONTROLLER_HOST}
GATEWAY_API_HOST=${GATEWAY_HOST}
VSAN_API_HOST=${VSAN_HOST}
EOF
echo "VERSION=$(cat src/VERSION)" >> .env

# Pass control to the CMD instruction (npm start)
exec "$@"
