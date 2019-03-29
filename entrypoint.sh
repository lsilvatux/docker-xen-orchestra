#!/bin/bash
sed -i "s/^port.*/port = $XO_PORT/" /opt/xen-orchestra/packages/xo-server/.xo-server.toml
sed -i "s/@redishost@/$REDIS_HOST/" /opt/xen-orchestra/packages/xo-server/.xo-server.toml

#cd /opt/xen-orchestra/packages/xo-server
exec "$@"
