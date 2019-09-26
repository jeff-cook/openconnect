#! /bin/sh

# https://www.infradead.org/openconnect/index.html
openconnect --version
echo
openssl version
echo

env | sort | grep OPENCONNECT_

OPTIONS="$( \
          env | \
          grep ^OPENCONNECT_ | \
          grep -v ^OPENCONNECT_PASSWORD_FILE= | \
          grep -v ^OPENCONNECT_SERVER= | \
          grep -v ^OPENCONNECT_SUDO= | \
          grep -v =false$ | \
          awk -F'=' '{gsub("^OPENCONNECT_", "--", $1); gsub("_", "-", $1); print tolower($1) "=" $2}' | \
          awk '{gsub("=true", "", $0); print $0}' | \
          xargs \
        )"

if [ $OCPROXY_ENABLED ]; then
  export OCPROXY_PORT=${OCPROXY_PORT:-1080}

  OPTIONS="$OPTIONS --script-tun --script=$( dirname "${BASH_SOURCE[0]}" )/ocproxy.sh"

cat << EOF > ~/proxy.env
# export http_proxy=socks5://localhost:$OCPROXY_PORT
# export https_proxy=socks5://localhost:$OCPROXY_PORT
# export ftp_proxy=socks5://localhost:$OCPROXY_PORT
# export rsync_proxy=socks5://localhost:$OCPROXY_PORT
# export all_proxy=socks5://localhost:$OCPROXY_PORT
# export ALL_PROXY=socks5://localhost:$OCPROXY_PORT
# export ssh_proxy='ProxyCommand=ssh -S localhost:$OCPROXY_PORT %h %p'
EOF

fi

echo
echo OPTIONS=$OPTIONS
echo
if [ -f $OPENCONNECT_CONFIG ]; then
  echo Config file $OPENCONNECT_CONFIG ...
  cat $OPENCONNECT_CONFIG
  echo
fi

echo Starting openconnect
echo

if [ -f $OPENCONNECT_PASSWORD_FILE ]; then
  OPTIONS="$OPTIONS --passwd-on-stdin"
  exec openconnect ${OPTIONS} ${OPENCONNECT_SERVER} < $OPENCONNECT_PASSWORD_FILE
else
  exec openconnect ${OPTIONS} ${OPENCONNECT_SERVER}
fi
