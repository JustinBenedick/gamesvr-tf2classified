# escape=`
FROM lacledeslan/steamcmd AS tf2class-builder

ARG SKIP_STEAMCMD=false

# Copy cached build files (if any)
COPY ./dist/build-cache /output

# Download TF2 Classified Dedicated Server
RUN mkdir --parents /output &&`
    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 3557020 validate +quit;

FROM lacledeslan/gamesvr-tf2:64-bit

HEALTHCHECK NONE

ARG BUILDNODE="unspecified"
ARG SOURCE_COMMIT

LABEL maintainer="Laclede's LAN <contact @lacledeslan.com>" `
      com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="LL Team Fortress 2 Claassified" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/gamesvr-tf2-classified"


COPY --chown=TF2:root --from=tf2class-builder /output /app
COPY --chown=TF2:root ./dist /app/classified
#COPY --chown=TF2:root ./ll-tests/*.sh /app/ll-tests


# UPDATE USERNAME & ensure permissions
RUN usermod -l TF2classified TF2 &&`
    chmod +x /app/ll-tests/*.sh &&`
    mkdir -p /app/tf2/logs &&`
    chmod 774 /app/tf2/logs

USER TF2classified

WORKDIR /app/

CMD ["/bin/bash"]

ONBUILD USER root