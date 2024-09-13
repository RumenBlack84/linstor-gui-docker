# syntax=docker/dockerfile:1

# Get linstor-gui src
FROM node:20.14-alpine3.20 AS src

ARG LINSTOR_GUI_VERSION=v1.8.1

RUN apk add --no-cache git && \
    git clone -c advice.detachedHead=false -b ${LINSTOR_GUI_VERSION} https://github.com/LINBIT/linstor-gui.git /opt/linstor-gui && \
    echo ${LINSTOR_GUI_VERSION} > /opt/linstor-gui/src/VERSION

FROM node:20.14-alpine3.20

WORKDIR /opt/linstor-gui/app

# Copy app src
COPY --from=src /opt/linstor-gui/src src
COPY --from=src /opt/linstor-gui/stylePaths.js .
COPY --from=src /opt/linstor-gui/webpack.common.js .
COPY --from=src /opt/linstor-gui/webpack.dev.js .
COPY --from=src /opt/linstor-gui/package.json .
COPY --from=src /opt/linstor-gui/package-lock.json .
COPY --from=src /opt/linstor-gui/tsconfig.json .

# Create linstor-gui user
RUN addgroup -g 666 linstor-gui && \
    adduser -D -s /sbin/nologin -u 666 -G linstor-gui \
            -h /opt/linstor-gui/app linstor-gui && \
    chown -R linstor-gui:linstor-gui /opt/linstor-gui/app

# Copy the startup script
COPY entrypoint.sh /opt/linstor-gui/entrypoint.sh
RUN chmod +x /opt/linstor-gui/entrypoint.sh

USER linstor-gui
RUN npm install --no-update-notifier

ENTRYPOINT ["/opt/linstor-gui/entrypoint.sh"]
CMD ["npm", "run", "start:dev"]

# TCP Ports
EXPOSE 8080
