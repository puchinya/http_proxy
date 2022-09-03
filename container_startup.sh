#!/bin/sh

htpasswd -bc /etc/squid/.htpasswd "${SQUID_CONFIG_AUTH_BASIC_ID}" "${SQUID_CONFIG_AUTH_BASIC_PASSWORD}"

cp -f template_squid.conf /etc/squid/squid.conf

replace() {
  sed -ie "s/${2}/${3}/" "${1}"
}

replace_squid_conf() {
  replace /etc/squid/squid.conf "${1}" "${2}"
}

replace_squid_conf "%SQUID_CONFIG_PORT%" ${SQUID_CONFIG_PORT}

chown squid:squid /dev/stdout
/usr/sbin/squid -N -f /etc/squid/squid.conf
