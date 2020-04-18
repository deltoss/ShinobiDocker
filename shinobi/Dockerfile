FROM node:alpine3.11

LABEL Author="Deltoss, MiGoller, mrproper, pschmitt & moeiscool"

# Set environment variables to default values
# ADMIN_USER : the super user login name
# ADMIN_PASSWORD : the super user login password
# PLUGINKEY_MOTION : motion plugin connection key
# PLUGINKEY_OPENCV : opencv plugin connection key
# PLUGINKEY_OPENALPR : openalpr plugin connection key
ENV ADMIN_USER=admin@shinobi.video \
    ADMIN_PASSWORD=admin \
    CRON_KEY=fd6c7849-904d-47ea-922b-5143358ba0de \
    PLUGINKEY_MOTION=b7502fd9-506c-4dda-9b56-8e699a6bc41c \
    PLUGINKEY_OPENCV=f078bcfe-c39a-4eb5-bd52-9382ca828e8a \
    PLUGINKEY_OPENALPR=dbff574e-9d4a-44c1-b578-3dc0f1944a3c \
    DATABASE_HOST=mariadb \
    DATABASE_USER=root \
    DATABASE_PASSWORD=root \
    DATABASE_PORT=3306

# Create additional directories for: Custom configuration, working directory, database directory
RUN mkdir -p \
        /config \
        /opt/shinobi

# Install package dependencies
RUN apk update && \
    apk add --no-cache \ 
        freetype-dev \ 
        gnutls-dev \ 
        lame-dev \ 
        libass-dev \ 
        libogg-dev \ 
        libtheora-dev \ 
        libvorbis-dev \ 
        libvpx-dev \ 
        libwebp-dev \ 
        libssh2 \ 
        opus-dev \ 
        rtmpdump-dev \ 
        x264-dev \ 
        x265-dev \ 
        yasm-dev && \
    apk add --no-cache --virtual \ 
        .build-dependencies \ 
        build-base \ 
        bzip2 \ 
        coreutils \ 
        gnutls \ 
        nasm \ 
        tar \ 
        x264 \ 
        git \ 
        mariadb-client

# Install ffmpeg static build version from cdn.shinobi.video
RUN wget https://cdn.shinobi.video/installers/ffmpeg-release-64bit-static.tar.xz && \
    tar xpvf ./ffmpeg-release-64bit-static.tar.xz -C ./ && \
    cp -f ./ffmpeg-3.3.4-64bit-static/ff* /usr/bin/ && \
    chmod +x /usr/bin/ff* && \
    rm -f ffmpeg-release-64bit-static.tar.xz && \
    rm -rf ./ffmpeg-3.3.4-64bit-static

WORKDIR /opt/shinobi

# Clone the Shinobi CCTV PRO repo and install Shinobi app including NodeJS dependencies
RUN git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /opt/shinobi && \
    npm i npm@latest -g && \
    npm install pm2 -g && \
    npm install

# Copy code
COPY docker-entrypoint.sh pm2Shinobi.yml ./
RUN chmod -f +x ./*.sh

# Copy default configuration files
COPY ./config/conf.sample.json ./config/super.sample.json /opt/shinobi/

VOLUME ["/opt/shinobi/videos"]
VOLUME ["/config"]

EXPOSE 8080

ENTRYPOINT ["/opt/shinobi/docker-entrypoint.sh"]

CMD ["pm2-docker", "pm2Shinobi.yml"]