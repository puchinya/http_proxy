#!/bin/sh

htpasswd -bc /etc/squid/.htpasswd "${SQUID_CONFIG_AUTH_BASIC_ID}" "${SQUID_CONFIG_AUTH_BASIC_PASSWORD}"

cp -f template_squid.conf /etc/squid/squid.conf

replace() {
  ESCAPED_REPLACE=$(printf '%s\n' "$2"|sed -e 's/[]\/$.^[]/\\&/g');
  sed -ie "s/$1/${ESCAPED_REPLACE}/g" "$3"
}

replace_squid_conf() {
  replace "$1" "$2" /etc/squid/squid.conf
}

if [ "${SQUID_CONFIG_TLS_ENABLE}" = "true" ]
then
  echo "$SQUID_CONFIG_TLS_SERVER_CERT_PEM" > /opt/http_proxy/server.crt
  echo "$SQUID_CONFIG_TLS_SERVER_KEY_PEM" > /opt/http_proxy/private.key
  SQUID_CONFIG_PORT_REP="https_port ${SQUID_CONFIG_PORT} cert=/opt/http_proxy/server.crt key=/opt/http_proxy/private.key"
  echo "${SQUID_CONFIG_PORT_REP}"
  replace_squid_conf "%SQUID_CONFIG_PORT_LINE%" "${SQUID_CONFIG_PORT_REP}"
else
  replace_squid_conf "%SQUID_CONFIG_PORT_LINE%" "http_port ${SQUID_CONFIG_PORT}"
fi

chown squid:squid /dev/stdout
/usr/sbin/squid -N -f /etc/squid/squid.conf
