FROM mriedmann/mini-base
MAINTAINER Michael Riedmann <michael_riedmann@live.com>

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
    echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add -U iojs ca-certificates python make gcc libc-dev g++ && \
    apk upgrade 

RUN adduser ghost -D -h /ghost -s /bin/sh && \
    mkdir /data && \
    mkdir -p /opt/ghost

ADD https://github.com/TryGhost/Ghost/releases/download/0.6.4/Ghost-0.6.4.zip /tmp/ghost.zip
RUN cd /opt/ghost && \
    unzip /tmp/ghost.zip && \
    rm /tmp/ghost.zip

RUN cd /opt/ghost && \
    npm install sqlite3 --build-from-source 

RUN cd /opt/ghost && \
    npm install --production && \
    sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
    sed -i 's/"iojs": "~1.2.0"/"iojs": "~1.6.4"/' package.json && \
    chown -R ghost.ghost *

#CleanUp
RUN apk del wget ca-certificates python make gcc libc-dev g++ && \
    npm cache clean && \
    rm -rf /var/cache/apk/* /tmp/* /root/.node-gyp

ENV NODE_ENV production
ENV GHOST_URL http://blog.born2think.eu

WORKDIR /opt/ghost
VOLUME ["/data"]
USER ghost

#ADD run /usr/local/bin/run
#RUN chmod +x /usr/local/bin/run
#ADD config.js /opt/ghost/config.js

#RUN chown -R ghost:ghost /opt/ghost

EXPOSE 2368
CMD ["/usr/local/bin/run"]
