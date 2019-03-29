FROM debian:stretch-slim

RUN apt-get update && apt-get -y install aptitude && \
	aptitude -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common \
	build-essential libpng-dev git python-minimal libvhdi-utils lvm2 cifs-utils

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    aptitude update && \
    aptitude install -y nodejs yarn



RUN cd /opt && git clone -b master https://github.com/vatesfr/xen-orchestra.git && \
    cd xen-orchestra && \
    yarn && yarn build

ENV XO_PORT 80
# Syntax: redis://[db[:password]@]hostname[:port][/db-number]
ENV REDIS_HOST redis:6379

COPY .xo-server.toml /opt/xen-orchestra/packages/xo-server/.xo-server.toml 

#RUN sed -i "s/^port.*/port = $XO_PORT/" /opt/xen-orchestra/packages/xo-server/.xo-server.toml && \
#    sed -i "s/^uri.*/uri = \'redis:\/\/$REDIS_HOST\'/" /opt/xen-orchestra/packages/xo-server/.xo-server.toml

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD cd /opt/xen-orchestra/packages/xo-server && /usr/bin/yarn start
