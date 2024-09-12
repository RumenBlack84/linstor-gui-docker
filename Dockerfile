# syntax=docker/dockerfile:1

FROM node:18.20-alpine3.20

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    git \
    bash \
    shadow && \
  useradd -ms /bin/bash linstor-gui && \
  mkdir -p /config && \
  chsh -s /bin/bash root
  
# Declaring a volume so we can attempt to preserve the configuration for the gui
VOLUME /config

# Copy the startup script
COPY entrypoint.sh /home/linstor-gui/entrypoint.sh
RUN chmod +x /home/linstor-gui/entrypoint.sh

USER linstor-gui

# Set working directory to where we have the linstor-gui files
WORKDIR /config

ENTRYPOINT ["/home/linstor-gui/entrypoint.sh"]
CMD ["npm", "--prefix", "/config", "run", "start:dev"]

# TCP Ports
EXPOSE 8080
