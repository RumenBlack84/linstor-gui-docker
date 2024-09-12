# syntax=docker/dockerfile:1

FROM node:18.20-alpine3.20

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    git && \
  useradd -ms /bin/bash linstor-gui && \
  mkdir -p /config && \
  chsh -s /bin/bash root
  
# Copy the startup script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set version variable to main so if nothing if specified just the latest entry for the github will be cloned
ENV VERSION=main

# Declaring a volume so we can attempt to preserve the configuration for the gui
VOLUME /config

USER linstor-gui

# Set working directory to the adlumin files
WORKDIR /config

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["npm", "--prefix", "/path/to/your-directory", "run", "start:dev"]

# TCP Ports
EXPOSE 8080
