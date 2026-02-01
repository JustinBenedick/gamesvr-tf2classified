# escape=`
FROM lacledeslan/steamcmd AS tf2class-builder

ARG SKIP_STEAMCMD=false

# Copy cached build files (if any)
COPY ./dist/build-cache /output

# Download TF2 Classified Dedicated Server
RUN mkdir --parents /output &&`
    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 3557020 validate +quit;


# Grab x64 version of steamclient.so
RUN mkdir --parents /output/.steam/sdk64/ /app/ll-tests &&`
    cp /app/linux64/steamclient.so /output/.steam/sdk64/steamclient.so;

FROM debian:trixie-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

RUN apt-get update &&`
    dpkg --add-architecture i386 &&`
    apt-get install --no-install-recommends --no-install-suggests -y `
        ca-certificates locales locales-all glibc-source tmux &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* &&`
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment &&`
    useradd --home /app --gid root --system TF2class &&`
    mkdir --parents /app &&`
    chown TF2class:root -R /app;

COPY --chown=TF2class:root --from=tf2class-builder /output /app

USER TF2class

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
