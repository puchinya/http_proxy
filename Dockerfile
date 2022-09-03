FROM alpine:3.16.2

RUN apk --update --no-cache add 'squid=5.5-r0' apache2-utils

ENV SQUID_CONFIG_PORT=38080
# basic only
ENV SQUID_CONFIG_AUTH_TYPE=basic
ENV SQUID_CONFIG_AUTH_BASIC_ID=http_proxy_login
ENV SQUID_CONFIG_AUTH_BASIC_PASSWORD=Http_Proxy_PassWd_1234

EXPOSE 38080

WORKDIR /opt/http_proxy/
COPY template_squid.conf /opt/http_proxy/
COPY container_startup.sh /opt/http_proxy/
RUN /usr/sbin/squid -N -z

CMD ["sh", "container_startup.sh"]
