FROM ubuntu

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude='./bin' && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin

ENV TZ=Europe/Moscow
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y \
    tzdata \
    net-tools \
    curl \
    socat \
    cron \
    procps \
    nginx \
    bind9 \
    dnsutils \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

RUN curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/nginx/dhparam

RUN curl https://raw.githubusercontent.com/dehydrated-io/dehydrated/master/dehydrated > /root/dehydrated

RUN mkdir -p /var/www/dehydrated

COPY etc/ /etc

ENTRYPOINT ["/init"]

EXPOSE 80
EXPOSE 443
EXPOSE 53
EXPOSE 53/udp
